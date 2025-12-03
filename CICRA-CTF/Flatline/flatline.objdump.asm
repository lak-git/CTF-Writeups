
flatline:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <.init>:
    1000:	f3 0f 1e fa          	endbr64
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 c1 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fc1]        # 3fd0 <printf@plt+0x2f80>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <puts@plt-0x1a>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret

Disassembly of section .plt:

0000000000001020 <puts@plt-0x10>:
    1020:	ff 35 ca 2f 00 00    	push   QWORD PTR [rip+0x2fca]        # 3ff0 <printf@plt+0x2fa0>
    1026:	ff 25 cc 2f 00 00    	jmp    QWORD PTR [rip+0x2fcc]        # 3ff8 <printf@plt+0x2fa8>
    102c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000001030 <puts@plt>:
    1030:	ff 25 ca 2f 00 00    	jmp    QWORD PTR [rip+0x2fca]        # 4000 <printf@plt+0x2fb0>
    1036:	68 00 00 00 00       	push   0x0
    103b:	e9 e0 ff ff ff       	jmp    1020 <puts@plt-0x10>

0000000000001040 <strlen@plt>:
    1040:	ff 25 c2 2f 00 00    	jmp    QWORD PTR [rip+0x2fc2]        # 4008 <printf@plt+0x2fb8>
    1046:	68 01 00 00 00       	push   0x1
    104b:	e9 d0 ff ff ff       	jmp    1020 <puts@plt-0x10>

0000000000001050 <printf@plt>:
    1050:	ff 25 ba 2f 00 00    	jmp    QWORD PTR [rip+0x2fba]        # 4010 <printf@plt+0x2fc0>
    1056:	68 02 00 00 00       	push   0x2
    105b:	e9 c0 ff ff ff       	jmp    1020 <puts@plt-0x10>

Disassembly of section .text:

0000000000001060 <.text>:
    1060:	f3 0f 1e fa          	endbr64
    1064:	31 ed                	xor    ebp,ebp
    1066:	49 89 d1             	mov    r9,rdx
    1069:	5e                   	pop    rsi
    106a:	48 89 e2             	mov    rdx,rsp
    106d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    1071:	50                   	push   rax
    1072:	54                   	push   rsp
    1073:	45 31 c0             	xor    r8d,r8d
    1076:	31 c9                	xor    ecx,ecx
    1078:	48 8d 3d da 00 00 00 	lea    rdi,[rip+0xda]        # 1159 <printf@plt+0x109>
    107f:	ff 15 3b 2f 00 00    	call   QWORD PTR [rip+0x2f3b]        # 3fc0 <printf@plt+0x2f70>
    1085:	f4                   	hlt
    1086:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    108d:	00 00 00 
    1090:	48 8d 3d 91 2f 00 00 	lea    rdi,[rip+0x2f91]        # 4028 <printf@plt+0x2fd8>
    1097:	48 8d 05 8a 2f 00 00 	lea    rax,[rip+0x2f8a]        # 4028 <printf@plt+0x2fd8>
    109e:	48 39 f8             	cmp    rax,rdi
    10a1:	74 15                	je     10b8 <printf@plt+0x68>
    10a3:	48 8b 05 1e 2f 00 00 	mov    rax,QWORD PTR [rip+0x2f1e]        # 3fc8 <printf@plt+0x2f78>
    10aa:	48 85 c0             	test   rax,rax
    10ad:	74 09                	je     10b8 <printf@plt+0x68>
    10af:	ff e0                	jmp    rax
    10b1:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    10b8:	c3                   	ret
    10b9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    10c0:	48 8d 3d 61 2f 00 00 	lea    rdi,[rip+0x2f61]        # 4028 <printf@plt+0x2fd8>
    10c7:	48 8d 35 5a 2f 00 00 	lea    rsi,[rip+0x2f5a]        # 4028 <printf@plt+0x2fd8>
    10ce:	48 29 fe             	sub    rsi,rdi
    10d1:	48 89 f0             	mov    rax,rsi
    10d4:	48 c1 ee 3f          	shr    rsi,0x3f
    10d8:	48 c1 f8 03          	sar    rax,0x3
    10dc:	48 01 c6             	add    rsi,rax
    10df:	48 d1 fe             	sar    rsi,1
    10e2:	74 14                	je     10f8 <printf@plt+0xa8>
    10e4:	48 8b 05 ed 2e 00 00 	mov    rax,QWORD PTR [rip+0x2eed]        # 3fd8 <printf@plt+0x2f88>
    10eb:	48 85 c0             	test   rax,rax
    10ee:	74 08                	je     10f8 <printf@plt+0xa8>
    10f0:	ff e0                	jmp    rax
    10f2:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    10f8:	c3                   	ret
    10f9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1100:	f3 0f 1e fa          	endbr64
    1104:	80 3d 1d 2f 00 00 00 	cmp    BYTE PTR [rip+0x2f1d],0x0        # 4028 <printf@plt+0x2fd8>
    110b:	75 33                	jne    1140 <printf@plt+0xf0>
    110d:	55                   	push   rbp
    110e:	48 83 3d ca 2e 00 00 	cmp    QWORD PTR [rip+0x2eca],0x0        # 3fe0 <printf@plt+0x2f90>
    1115:	00 
    1116:	48 89 e5             	mov    rbp,rsp
    1119:	74 0d                	je     1128 <printf@plt+0xd8>
    111b:	48 8b 3d fe 2e 00 00 	mov    rdi,QWORD PTR [rip+0x2efe]        # 4020 <printf@plt+0x2fd0>
    1122:	ff 15 b8 2e 00 00    	call   QWORD PTR [rip+0x2eb8]        # 3fe0 <printf@plt+0x2f90>
    1128:	e8 63 ff ff ff       	call   1090 <printf@plt+0x40>
    112d:	c6 05 f4 2e 00 00 01 	mov    BYTE PTR [rip+0x2ef4],0x1        # 4028 <printf@plt+0x2fd8>
    1134:	5d                   	pop    rbp
    1135:	c3                   	ret
    1136:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    113d:	00 00 00 
    1140:	c3                   	ret
    1141:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    1145:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    114c:	00 00 00 00 
    1150:	f3 0f 1e fa          	endbr64
    1154:	e9 67 ff ff ff       	jmp    10c0 <printf@plt+0x70>
    1159:	55                   	push   rbp
    115a:	48 89 e5             	mov    rbp,rsp
    115d:	48 83 ec 30          	sub    rsp,0x30
    1161:	89 7d dc             	mov    DWORD PTR [rbp-0x24],edi
    1164:	48 89 75 d0          	mov    QWORD PTR [rbp-0x30],rsi
    1168:	83 7d dc 02          	cmp    DWORD PTR [rbp-0x24],0x2
    116c:	74 28                	je     1196 <printf@plt+0x146>
    116e:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
    1172:	48 8b 00             	mov    rax,QWORD PTR [rax]
    1175:	48 8d 15 b0 0e 00 00 	lea    rdx,[rip+0xeb0]        # 202c <printf@plt+0xfdc>
    117c:	48 89 c6             	mov    rsi,rax
    117f:	48 89 d7             	mov    rdi,rdx
    1182:	b8 00 00 00 00       	mov    eax,0x0
    1187:	e8 c4 fe ff ff       	call   1050 <printf@plt>
    118c:	b8 01 00 00 00       	mov    eax,0x1
    1191:	e9 8c 01 00 00       	jmp    1322 <printf@plt+0x2d2>
    1196:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
    119a:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
    119e:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
    11a2:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    11a6:	48 89 c7             	mov    rdi,rax
    11a9:	e8 92 fe ff ff       	call   1040 <strlen@plt>
    11ae:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    11b2:	c7 45 e4 00 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x0
    11b9:	c7 45 e8 00 00 00 00 	mov    DWORD PTR [rbp-0x18],0x0
    11c0:	c6 45 e3 00          	mov    BYTE PTR [rbp-0x1d],0x0
    11c4:	c7 45 ec 01 00 00 00 	mov    DWORD PTR [rbp-0x14],0x1
    11cb:	83 7d e4 06          	cmp    DWORD PTR [rbp-0x1c],0x6
    11cf:	0f 84 2b 01 00 00    	je     1300 <printf@plt+0x2b0>
    11d5:	83 7d e4 06          	cmp    DWORD PTR [rbp-0x1c],0x6
    11d9:	0f 87 37 01 00 00    	ja     1316 <printf@plt+0x2c6>
    11df:	83 7d e4 05          	cmp    DWORD PTR [rbp-0x1c],0x5
    11e3:	0f 84 01 01 00 00    	je     12ea <printf@plt+0x29a>
    11e9:	83 7d e4 05          	cmp    DWORD PTR [rbp-0x1c],0x5
    11ed:	0f 87 23 01 00 00    	ja     1316 <printf@plt+0x2c6>
    11f3:	83 7d e4 04          	cmp    DWORD PTR [rbp-0x1c],0x4
    11f7:	0f 84 b9 00 00 00    	je     12b6 <printf@plt+0x266>
    11fd:	83 7d e4 04          	cmp    DWORD PTR [rbp-0x1c],0x4
    1201:	0f 87 0f 01 00 00    	ja     1316 <printf@plt+0x2c6>
    1207:	83 7d e4 03          	cmp    DWORD PTR [rbp-0x1c],0x3
    120b:	74 69                	je     1276 <printf@plt+0x226>
    120d:	83 7d e4 03          	cmp    DWORD PTR [rbp-0x1c],0x3
    1211:	0f 87 ff 00 00 00    	ja     1316 <printf@plt+0x2c6>
    1217:	83 7d e4 02          	cmp    DWORD PTR [rbp-0x1c],0x2
    121b:	74 46                	je     1263 <printf@plt+0x213>
    121d:	83 7d e4 02          	cmp    DWORD PTR [rbp-0x1c],0x2
    1221:	0f 87 ef 00 00 00    	ja     1316 <printf@plt+0x2c6>
    1227:	83 7d e4 00          	cmp    DWORD PTR [rbp-0x1c],0x0
    122b:	74 0b                	je     1238 <printf@plt+0x1e8>
    122d:	83 7d e4 01          	cmp    DWORD PTR [rbp-0x1c],0x1
    1231:	74 11                	je     1244 <printf@plt+0x1f4>
    1233:	e9 de 00 00 00       	jmp    1316 <printf@plt+0x2c6>
    1238:	c7 45 e4 01 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x1
    123f:	e9 d9 00 00 00       	jmp    131d <printf@plt+0x2cd>
    1244:	48 83 7d f8 1c       	cmp    QWORD PTR [rbp-0x8],0x1c
    1249:	74 0c                	je     1257 <printf@plt+0x207>
    124b:	c7 45 e4 06 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x6
    1252:	e9 c6 00 00 00       	jmp    131d <printf@plt+0x2cd>
    1257:	c7 45 e4 02 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x2
    125e:	e9 ba 00 00 00       	jmp    131d <printf@plt+0x2cd>
    1263:	c7 45 e8 00 00 00 00 	mov    DWORD PTR [rbp-0x18],0x0
    126a:	c7 45 e4 03 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x3
    1271:	e9 a7 00 00 00       	jmp    131d <printf@plt+0x2cd>
    1276:	8b 55 e8             	mov    edx,DWORD PTR [rbp-0x18]
    1279:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    127d:	48 01 d0             	add    rax,rdx
    1280:	0f b6 00             	movzx  eax,BYTE PTR [rax]
    1283:	89 c2                	mov    edx,eax
    1285:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
    1288:	83 c0 01             	add    eax,0x1
    128b:	31 d0                	xor    eax,edx
    128d:	83 c0 0a             	add    eax,0xa
    1290:	88 45 e3             	mov    BYTE PTR [rbp-0x1d],al
    1293:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
    1296:	48 8d 15 73 0d 00 00 	lea    rdx,[rip+0xd73]        # 2010 <printf@plt+0xfc0>
    129d:	0f b6 04 10          	movzx  eax,BYTE PTR [rax+rdx*1]
    12a1:	38 45 e3             	cmp    BYTE PTR [rbp-0x1d],al
    12a4:	74 07                	je     12ad <printf@plt+0x25d>
    12a6:	c7 45 ec 00 00 00 00 	mov    DWORD PTR [rbp-0x14],0x0
    12ad:	c7 45 e4 04 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x4
    12b4:	eb 67                	jmp    131d <printf@plt+0x2cd>
    12b6:	83 45 e8 01          	add    DWORD PTR [rbp-0x18],0x1
    12ba:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
    12bd:	48 3b 45 f8          	cmp    rax,QWORD PTR [rbp-0x8]
    12c1:	73 0f                	jae    12d2 <printf@plt+0x282>
    12c3:	83 7d ec 00          	cmp    DWORD PTR [rbp-0x14],0x0
    12c7:	74 09                	je     12d2 <printf@plt+0x282>
    12c9:	c7 45 e4 03 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x3
    12d0:	eb 4b                	jmp    131d <printf@plt+0x2cd>
    12d2:	83 7d ec 00          	cmp    DWORD PTR [rbp-0x14],0x0
    12d6:	75 09                	jne    12e1 <printf@plt+0x291>
    12d8:	c7 45 e4 06 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x6
    12df:	eb 3c                	jmp    131d <printf@plt+0x2cd>
    12e1:	c7 45 e4 05 00 00 00 	mov    DWORD PTR [rbp-0x1c],0x5
    12e8:	eb 33                	jmp    131d <printf@plt+0x2cd>
    12ea:	48 8d 05 4d 0d 00 00 	lea    rax,[rip+0xd4d]        # 203e <printf@plt+0xfee>
    12f1:	48 89 c7             	mov    rdi,rax
    12f4:	e8 37 fd ff ff       	call   1030 <puts@plt>
    12f9:	b8 00 00 00 00       	mov    eax,0x0
    12fe:	eb 22                	jmp    1322 <printf@plt+0x2d2>
    1300:	48 8d 05 53 0d 00 00 	lea    rax,[rip+0xd53]        # 205a <printf@plt+0x100a>
    1307:	48 89 c7             	mov    rdi,rax
    130a:	e8 21 fd ff ff       	call   1030 <puts@plt>
    130f:	b8 01 00 00 00       	mov    eax,0x1
    1314:	eb 0c                	jmp    1322 <printf@plt+0x2d2>
    1316:	b8 ff ff ff ff       	mov    eax,0xffffffff
    131b:	eb 05                	jmp    1322 <printf@plt+0x2d2>
    131d:	e9 a9 fe ff ff       	jmp    11cb <printf@plt+0x17b>
    1322:	c9                   	leave
    1323:	c3                   	ret

Disassembly of section .fini:

0000000000001324 <.fini>:
    1324:	f3 0f 1e fa          	endbr64
    1328:	48 83 ec 08          	sub    rsp,0x8
    132c:	48 83 c4 08          	add    rsp,0x8
    1330:	c3                   	ret
