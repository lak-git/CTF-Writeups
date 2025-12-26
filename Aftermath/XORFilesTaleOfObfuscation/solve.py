import scapy.all as scapy
import base64
import gzip


def final_solve():
    packets = scapy.rdpcap("name.pcap")
    xor_key = 0xC0
    chunks = { }

    for pkt in packets:
        if pkt.haslayer('UDP'):
            payload = bytes(pkt['UDP'].payload)

            # Step 1: Reveal the Header
            decrypted_block = bytes([b ^ xor_key for b in payload])

            if b"IDX:" in decrypted_block:
                try:
                    header, encrypted_data = decrypted_block.split(b"|", 1)

                    # Step 2: Extract Sequence Number
                    # Format: IDX:num/total
                    seq_number = int(header.split(b":")[1].split(b"/")[0])

                    # Step 3: Reveal the actual Base64 text
                    # We XOR the encrypted_data part again to get the plaintext B64
                    b64_text = bytes([b ^ xor_key for b in encrypted_data])
                    chunks[seq_number] = b64_text
                    print(f"Recovered chunk {seq_number}: {b64_text[:30]}...")

                except Exception as e:
                    print(f"Error parsing chunk: {e}")

    # Step 4: Assemble and Process
    full_b64 = b"".join(chunks[i] for i in sorted(chunks.keys()))

    # Fix padding
    while len(full_b64) % 4 != 0:
        full_b64 += b"="

    try:
        # Step 5: Base64 -> Gzip --> Flag
        compressed_data = base64.b64decode(full_b64)
        flag = gzip.decompress(compressed_data)
        print("\n" + "="*30)
        print(f"Flag: {flag.decode('utf-8')}")
        print("="*30)
    except Exception as e:
        print(f"Error during final decoding: {e}")
        print(f"Assembled string: {full_b64.decode(errors='ignore')[:100]}")


if __name__ == "__main__":
    final_solve()