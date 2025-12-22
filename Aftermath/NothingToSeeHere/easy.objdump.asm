
easy.exe:     file format pei-x86-64


Disassembly of section .text:

0000000140001000 <.text>:
   140001000:	c3                   	ret
   140001001:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140001008:	00 00 00 00 
   14000100c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140001010:	41 57                	push   r15
   140001012:	41 56                	push   r14
   140001014:	41 55                	push   r13
   140001016:	41 54                	push   r12
   140001018:	55                   	push   rbp
   140001019:	57                   	push   rdi
   14000101a:	56                   	push   rsi
   14000101b:	53                   	push   rbx
   14000101c:	48 83 ec 58          	sub    rsp,0x58
   140001020:	b8 30 00 00 00       	mov    eax,0x30
   140001025:	65 67 48 8b 00       	mov    rax,QWORD PTR gs:[eax]
   14000102a:	48 8b 70 08          	mov    rsi,QWORD PTR [rax+0x8]
   14000102e:	48 8b 1d 1b 34 00 00 	mov    rbx,QWORD PTR [rip+0x341b]        # 0x140004450
   140001035:	48 8b 3d 54 71 00 00 	mov    rdi,QWORD PTR [rip+0x7154]        # 0x140008190
   14000103c:	eb 12                	jmp    0x140001050
   14000103e:	66 90                	xchg   ax,ax
   140001040:	48 39 c6             	cmp    rsi,rax
   140001043:	0f 84 af 00 00 00    	je     0x1400010f8
   140001049:	b9 e8 03 00 00       	mov    ecx,0x3e8
   14000104e:	ff d7                	call   rdi
   140001050:	31 c0                	xor    eax,eax
   140001052:	f0 48 0f b1 33       	lock cmpxchg QWORD PTR [rbx],rsi
   140001057:	75 e7                	jne    0x140001040
   140001059:	45 31 ed             	xor    r13d,r13d
   14000105c:	48 8b 3d fd 33 00 00 	mov    rdi,QWORD PTR [rip+0x33fd]        # 0x140004460
   140001063:	8b 07                	mov    eax,DWORD PTR [rdi]
   140001065:	83 f8 01             	cmp    eax,0x1
   140001068:	0f 84 4a 03 00 00    	je     0x1400013b8
   14000106e:	8b 07                	mov    eax,DWORD PTR [rdi]
   140001070:	85 c0                	test   eax,eax
   140001072:	0f 84 90 00 00 00    	je     0x140001108
   140001078:	c7 05 82 5f 00 00 01 	mov    DWORD PTR [rip+0x5f82],0x1        # 0x140007004
   14000107f:	00 00 00 
   140001082:	45 85 ed             	test   r13d,r13d
   140001085:	0f 84 8d 02 00 00    	je     0x140001318
   14000108b:	48 8b 05 1e 33 00 00 	mov    rax,QWORD PTR [rip+0x331e]        # 0x1400043b0
   140001092:	48 8b 00             	mov    rax,QWORD PTR [rax]
   140001095:	48 85 c0             	test   rax,rax
   140001098:	74 0c                	je     0x1400010a6
   14000109a:	45 31 c0             	xor    r8d,r8d
   14000109d:	ba 02 00 00 00       	mov    edx,0x2
   1400010a2:	31 c9                	xor    ecx,ecx
   1400010a4:	ff d0                	call   rax
   1400010a6:	e8 25 15 00 00       	call   0x1400025d0
   1400010ab:	4c 8b 05 5e 5f 00 00 	mov    r8,QWORD PTR [rip+0x5f5e]        # 0x140007010
   1400010b2:	8b 0d 68 5f 00 00    	mov    ecx,DWORD PTR [rip+0x5f68]        # 0x140007020
   1400010b8:	4c 89 00             	mov    QWORD PTR [rax],r8
   1400010bb:	48 8b 15 56 5f 00 00 	mov    rdx,QWORD PTR [rip+0x5f56]        # 0x140007018
   1400010c2:	e8 79 16 00 00       	call   0x140002740
   1400010c7:	8b 0d 3b 5f 00 00    	mov    ecx,DWORD PTR [rip+0x5f3b]        # 0x140007008
   1400010cd:	85 c9                	test   ecx,ecx
   1400010cf:	0f 84 ed 02 00 00    	je     0x1400013c2
   1400010d5:	8b 15 29 5f 00 00    	mov    edx,DWORD PTR [rip+0x5f29]        # 0x140007004
   1400010db:	85 d2                	test   edx,edx
   1400010dd:	0f 84 1d 02 00 00    	je     0x140001300
   1400010e3:	48 83 c4 58          	add    rsp,0x58
   1400010e7:	5b                   	pop    rbx
   1400010e8:	5e                   	pop    rsi
   1400010e9:	5f                   	pop    rdi
   1400010ea:	5d                   	pop    rbp
   1400010eb:	41 5c                	pop    r12
   1400010ed:	41 5d                	pop    r13
   1400010ef:	41 5e                	pop    r14
   1400010f1:	41 5f                	pop    r15
   1400010f3:	c3                   	ret
   1400010f4:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1400010f8:	41 bd 01 00 00 00    	mov    r13d,0x1
   1400010fe:	e9 59 ff ff ff       	jmp    0x14000105c
   140001103:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   140001108:	c7 07 01 00 00 00    	mov    DWORD PTR [rdi],0x1
   14000110e:	e8 ad 07 00 00       	call   0x1400018c0
   140001113:	48 8b 0d c6 33 00 00 	mov    rcx,QWORD PTR [rip+0x33c6]        # 0x1400044e0
   14000111a:	ff 15 68 70 00 00    	call   QWORD PTR [rip+0x7068]        # 0x140008188
   140001120:	48 8b 15 19 33 00 00 	mov    rdx,QWORD PTR [rip+0x3319]        # 0x140004440
   140001127:	48 8d 0d d2 fe ff ff 	lea    rcx,[rip+0xfffffffffffffed2]        # 0x140001000
   14000112e:	48 89 02             	mov    QWORD PTR [rdx],rax
   140001131:	e8 ba 14 00 00       	call   0x1400025f0
   140001136:	e8 e5 0f 00 00       	call   0x140002120
   14000113b:	48 8b 05 ce 32 00 00 	mov    rax,QWORD PTR [rip+0x32ce]        # 0x140004410
   140001142:	31 c9                	xor    ecx,ecx
   140001144:	c7 00 01 00 00 00    	mov    DWORD PTR [rax],0x1
   14000114a:	48 8b 05 cf 32 00 00 	mov    rax,QWORD PTR [rip+0x32cf]        # 0x140004420
   140001151:	c7 00 01 00 00 00    	mov    DWORD PTR [rax],0x1
   140001157:	48 8b 05 d2 32 00 00 	mov    rax,QWORD PTR [rip+0x32d2]        # 0x140004430
   14000115e:	c7 00 01 00 00 00    	mov    DWORD PTR [rax],0x1
   140001164:	48 8b 05 15 32 00 00 	mov    rax,QWORD PTR [rip+0x3215]        # 0x140004380
   14000116b:	66 81 38 4d 5a       	cmp    WORD PTR [rax],0x5a4d
   140001170:	75 3e                	jne    0x1400011b0
   140001172:	48 63 50 3c          	movsxd rdx,DWORD PTR [rax+0x3c]
   140001176:	48 01 d0             	add    rax,rdx
   140001179:	81 38 50 45 00 00    	cmp    DWORD PTR [rax],0x4550
   14000117f:	75 2f                	jne    0x1400011b0
   140001181:	0f b7 50 18          	movzx  edx,WORD PTR [rax+0x18]
   140001185:	66 81 fa 0b 01       	cmp    dx,0x10b
   14000118a:	0f 84 0a 02 00 00    	je     0x14000139a
   140001190:	66 81 fa 0b 02       	cmp    dx,0x20b
   140001195:	75 19                	jne    0x1400011b0
   140001197:	83 b8 84 00 00 00 0e 	cmp    DWORD PTR [rax+0x84],0xe
   14000119e:	76 10                	jbe    0x1400011b0
   1400011a0:	44 8b 88 f8 00 00 00 	mov    r9d,DWORD PTR [rax+0xf8]
   1400011a7:	31 c9                	xor    ecx,ecx
   1400011a9:	45 85 c9             	test   r9d,r9d
   1400011ac:	0f 95 c1             	setne  cl
   1400011af:	90                   	nop
   1400011b0:	48 8b 05 49 32 00 00 	mov    rax,QWORD PTR [rip+0x3249]        # 0x140004400
   1400011b7:	89 0d 4b 5e 00 00    	mov    DWORD PTR [rip+0x5e4b],ecx        # 0x140007008
   1400011bd:	44 8b 00             	mov    r8d,DWORD PTR [rax]
   1400011c0:	45 85 c0             	test   r8d,r8d
   1400011c3:	0f 85 5f 01 00 00    	jne    0x140001328
   1400011c9:	b9 01 00 00 00       	mov    ecx,0x1
   1400011ce:	e8 85 14 00 00       	call   0x140002658
   1400011d3:	e8 d8 13 00 00       	call   0x1400025b0
   1400011d8:	48 8b 15 f1 32 00 00 	mov    rdx,QWORD PTR [rip+0x32f1]        # 0x1400044d0
   1400011df:	8b 12                	mov    edx,DWORD PTR [rdx]
   1400011e1:	89 10                	mov    DWORD PTR [rax],edx
   1400011e3:	e8 d8 13 00 00       	call   0x1400025c0
   1400011e8:	48 8b 15 c1 32 00 00 	mov    rdx,QWORD PTR [rip+0x32c1]        # 0x1400044b0
   1400011ef:	8b 12                	mov    edx,DWORD PTR [rdx]
   1400011f1:	89 10                	mov    DWORD PTR [rax],edx
   1400011f3:	e8 38 03 00 00       	call   0x140001530
   1400011f8:	85 c0                	test   eax,eax
   1400011fa:	0f 88 f4 00 00 00    	js     0x1400012f4
   140001200:	48 8b 05 59 31 00 00 	mov    rax,QWORD PTR [rip+0x3159]        # 0x140004360
   140001207:	83 38 01             	cmp    DWORD PTR [rax],0x1
   14000120a:	0f 84 79 01 00 00    	je     0x140001389
   140001210:	48 8b 05 a9 31 00 00 	mov    rax,QWORD PTR [rip+0x31a9]        # 0x1400043c0
   140001217:	83 38 ff             	cmp    DWORD PTR [rax],0xffffffff
   14000121a:	0f 84 5a 01 00 00    	je     0x14000137a
   140001220:	48 8b 15 79 32 00 00 	mov    rdx,QWORD PTR [rip+0x3279]        # 0x1400044a0
   140001227:	48 8b 0d 62 32 00 00 	mov    rcx,QWORD PTR [rip+0x3262]        # 0x140004490
   14000122e:	e8 3d 13 00 00       	call   0x140002570
   140001233:	85 c0                	test   eax,eax
   140001235:	0f 85 35 01 00 00    	jne    0x140001370
   14000123b:	48 8b 05 be 32 00 00 	mov    rax,QWORD PTR [rip+0x32be]        # 0x140004500
   140001242:	4c 8d 05 c7 5d 00 00 	lea    r8,[rip+0x5dc7]        # 0x140007010
   140001249:	48 8d 15 c8 5d 00 00 	lea    rdx,[rip+0x5dc8]        # 0x140007018
   140001250:	48 8d 0d c9 5d 00 00 	lea    rcx,[rip+0x5dc9]        # 0x140007020
   140001257:	8b 00                	mov    eax,DWORD PTR [rax]
   140001259:	89 44 24 4c          	mov    DWORD PTR [rsp+0x4c],eax
   14000125d:	48 8b 05 5c 32 00 00 	mov    rax,QWORD PTR [rip+0x325c]        # 0x1400044c0
   140001264:	44 8b 08             	mov    r9d,DWORD PTR [rax]
   140001267:	48 8d 44 24 4c       	lea    rax,[rsp+0x4c]
   14000126c:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   140001271:	e8 d2 13 00 00       	call   0x140002648
   140001276:	85 c0                	test   eax,eax
   140001278:	78 7a                	js     0x1400012f4
   14000127a:	4c 63 25 9f 5d 00 00 	movsxd r12,DWORD PTR [rip+0x5d9f]        # 0x140007020
   140001281:	41 8d 4c 24 01       	lea    ecx,[r12+0x1]
   140001286:	48 63 c9             	movsxd rcx,ecx
   140001289:	48 c1 e1 03          	shl    rcx,0x3
   14000128d:	e8 1e 14 00 00       	call   0x1400026b0
   140001292:	48 89 c5             	mov    rbp,rax
   140001295:	48 85 c0             	test   rax,rax
   140001298:	74 5a                	je     0x1400012f4
   14000129a:	4c 8b 3d 77 5d 00 00 	mov    r15,QWORD PTR [rip+0x5d77]        # 0x140007018
   1400012a1:	45 85 e4             	test   r12d,r12d
   1400012a4:	0f 8e 92 00 00 00    	jle    0x14000133c
   1400012aa:	be 01 00 00 00       	mov    esi,0x1
   1400012af:	eb 20                	jmp    0x1400012d1
   1400012b1:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1400012b8:	49 8b 54 f7 f8       	mov    rdx,QWORD PTR [r15+rsi*8-0x8]
   1400012bd:	4d 89 f0             	mov    r8,r14
   1400012c0:	e8 f3 13 00 00       	call   0x1400026b8
   1400012c5:	48 8d 46 01          	lea    rax,[rsi+0x1]
   1400012c9:	49 39 f4             	cmp    r12,rsi
   1400012cc:	74 69                	je     0x140001337
   1400012ce:	48 89 c6             	mov    rsi,rax
   1400012d1:	49 8b 4c f7 f8       	mov    rcx,QWORD PTR [r15+rsi*8-0x8]
   1400012d6:	e8 f5 13 00 00       	call   0x1400026d0
   1400012db:	4c 8d 70 01          	lea    r14,[rax+0x1]
   1400012df:	4c 89 f1             	mov    rcx,r14
   1400012e2:	e8 c9 13 00 00       	call   0x1400026b0
   1400012e7:	48 89 44 f5 f8       	mov    QWORD PTR [rbp+rsi*8-0x8],rax
   1400012ec:	48 89 c1             	mov    rcx,rax
   1400012ef:	48 85 c0             	test   rax,rax
   1400012f2:	75 c4                	jne    0x1400012b8
   1400012f4:	b9 08 00 00 00       	mov    ecx,0x8
   1400012f9:	e8 6a 13 00 00       	call   0x140002668
   1400012fe:	66 90                	xchg   ax,ax
   140001300:	89 44 24 3c          	mov    DWORD PTR [rsp+0x3c],eax
   140001304:	e8 67 13 00 00       	call   0x140002670
   140001309:	8b 44 24 3c          	mov    eax,DWORD PTR [rsp+0x3c]
   14000130d:	e9 d1 fd ff ff       	jmp    0x1400010e3
   140001312:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   140001318:	31 c0                	xor    eax,eax
   14000131a:	48 87 03             	xchg   QWORD PTR [rbx],rax
   14000131d:	e9 69 fd ff ff       	jmp    0x14000108b
   140001322:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   140001328:	b9 02 00 00 00       	mov    ecx,0x2
   14000132d:	e8 26 13 00 00       	call   0x140002658
   140001332:	e9 9c fe ff ff       	jmp    0x1400011d3
   140001337:	4a 8d 44 e5 00       	lea    rax,[rbp+r12*8+0x0]
   14000133c:	48 c7 00 00 00 00 00 	mov    QWORD PTR [rax],0x0
   140001343:	48 8b 15 36 31 00 00 	mov    rdx,QWORD PTR [rip+0x3136]        # 0x140004480
   14000134a:	48 8b 0d 1f 31 00 00 	mov    rcx,QWORD PTR [rip+0x311f]        # 0x140004470
   140001351:	48 89 2d c0 5c 00 00 	mov    QWORD PTR [rip+0x5cc0],rbp        # 0x140007018
   140001358:	e8 1b 13 00 00       	call   0x140002678
   14000135d:	e8 ae 01 00 00       	call   0x140001510
   140001362:	c7 07 02 00 00 00    	mov    DWORD PTR [rdi],0x2
   140001368:	e9 15 fd ff ff       	jmp    0x140001082
   14000136d:	0f 1f 00             	nop    DWORD PTR [rax]
   140001370:	b8 ff 00 00 00       	mov    eax,0xff
   140001375:	e9 69 fd ff ff       	jmp    0x1400010e3
   14000137a:	b9 ff ff ff ff       	mov    ecx,0xffffffff
   14000137f:	e8 7c 12 00 00       	call   0x140002600
   140001384:	e9 97 fe ff ff       	jmp    0x140001220
   140001389:	48 8b 0d 60 31 00 00 	mov    rcx,QWORD PTR [rip+0x3160]        # 0x1400044f0
   140001390:	e8 0b 09 00 00       	call   0x140001ca0
   140001395:	e9 76 fe ff ff       	jmp    0x140001210
   14000139a:	83 78 74 0e          	cmp    DWORD PTR [rax+0x74],0xe
   14000139e:	0f 86 0c fe ff ff    	jbe    0x1400011b0
   1400013a4:	44 8b 90 e8 00 00 00 	mov    r10d,DWORD PTR [rax+0xe8]
   1400013ab:	31 c9                	xor    ecx,ecx
   1400013ad:	45 85 d2             	test   r10d,r10d
   1400013b0:	0f 95 c1             	setne  cl
   1400013b3:	e9 f8 fd ff ff       	jmp    0x1400011b0
   1400013b8:	b9 1f 00 00 00       	mov    ecx,0x1f
   1400013bd:	e8 a6 12 00 00       	call   0x140002668
   1400013c2:	89 c1                	mov    ecx,eax
   1400013c4:	e8 cf 12 00 00       	call   0x140002698
   1400013c9:	90                   	nop
   1400013ca:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   1400013d0:	48 83 ec 28          	sub    rsp,0x28
   1400013d4:	48 8b 05 25 30 00 00 	mov    rax,QWORD PTR [rip+0x3025]        # 0x140004400
   1400013db:	c7 00 01 00 00 00    	mov    DWORD PTR [rax],0x1
   1400013e1:	e8 2a fc ff ff       	call   0x140001010
   1400013e6:	90                   	nop
   1400013e7:	90                   	nop
   1400013e8:	48 83 c4 28          	add    rsp,0x28
   1400013ec:	c3                   	ret
   1400013ed:	0f 1f 00             	nop    DWORD PTR [rax]
   1400013f0:	48 83 ec 28          	sub    rsp,0x28
   1400013f4:	48 8b 05 05 30 00 00 	mov    rax,QWORD PTR [rip+0x3005]        # 0x140004400
   1400013fb:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
   140001401:	e8 0a fc ff ff       	call   0x140001010
   140001406:	90                   	nop
   140001407:	90                   	nop
   140001408:	48 83 c4 28          	add    rsp,0x28
   14000140c:	c3                   	ret
   14000140d:	0f 1f 00             	nop    DWORD PTR [rax]
   140001410:	e9 73 12 00 00       	jmp    0x140002688
   140001415:	90                   	nop
   140001416:	90                   	nop
   140001417:	90                   	nop
   140001418:	90                   	nop
   140001419:	90                   	nop
   14000141a:	90                   	nop
   14000141b:	90                   	nop
   14000141c:	90                   	nop
   14000141d:	90                   	nop
   14000141e:	90                   	nop
   14000141f:	90                   	nop
   140001420:	48 8d 0d 09 00 00 00 	lea    rcx,[rip+0x9]        # 0x140001430
   140001427:	e9 e4 ff ff ff       	jmp    0x140001410
   14000142c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140001430:	c3                   	ret
   140001431:	90                   	nop
   140001432:	90                   	nop
   140001433:	90                   	nop
   140001434:	90                   	nop
   140001435:	90                   	nop
   140001436:	90                   	nop
   140001437:	90                   	nop
   140001438:	90                   	nop
   140001439:	90                   	nop
   14000143a:	90                   	nop
   14000143b:	90                   	nop
   14000143c:	90                   	nop
   14000143d:	90                   	nop
   14000143e:	90                   	nop
   14000143f:	90                   	nop
   140001440:	48 83 ec 28          	sub    rsp,0x28
   140001444:	48 8b 05 b5 1b 00 00 	mov    rax,QWORD PTR [rip+0x1bb5]        # 0x140003000
   14000144b:	48 8b 00             	mov    rax,QWORD PTR [rax]
   14000144e:	48 85 c0             	test   rax,rax
   140001451:	74 2a                	je     0x14000147d
   140001453:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   14000145a:	00 00 00 00 
   14000145e:	66 90                	xchg   ax,ax
   140001460:	ff d0                	call   rax
   140001462:	48 8b 05 97 1b 00 00 	mov    rax,QWORD PTR [rip+0x1b97]        # 0x140003000
   140001469:	48 8d 50 08          	lea    rdx,[rax+0x8]
   14000146d:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
   140001471:	48 89 15 88 1b 00 00 	mov    QWORD PTR [rip+0x1b88],rdx        # 0x140003000
   140001478:	48 85 c0             	test   rax,rax
   14000147b:	75 e3                	jne    0x140001460
   14000147d:	48 83 c4 28          	add    rsp,0x28
   140001481:	c3                   	ret
   140001482:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140001489:	00 00 00 00 
   14000148d:	0f 1f 00             	nop    DWORD PTR [rax]
   140001490:	56                   	push   rsi
   140001491:	53                   	push   rbx
   140001492:	48 83 ec 28          	sub    rsp,0x28
   140001496:	48 8b 15 d3 2e 00 00 	mov    rdx,QWORD PTR [rip+0x2ed3]        # 0x140004370
   14000149d:	48 8b 02             	mov    rax,QWORD PTR [rdx]
   1400014a0:	89 c1                	mov    ecx,eax
   1400014a2:	83 f8 ff             	cmp    eax,0xffffffff
   1400014a5:	74 39                	je     0x1400014e0
   1400014a7:	85 c9                	test   ecx,ecx
   1400014a9:	74 20                	je     0x1400014cb
   1400014ab:	89 c8                	mov    eax,ecx
   1400014ad:	83 e9 01             	sub    ecx,0x1
   1400014b0:	48 8d 1c c2          	lea    rbx,[rdx+rax*8]
   1400014b4:	48 29 c8             	sub    rax,rcx
   1400014b7:	48 8d 74 c2 f8       	lea    rsi,[rdx+rax*8-0x8]
   1400014bc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1400014c0:	ff 13                	call   QWORD PTR [rbx]
   1400014c2:	48 83 eb 08          	sub    rbx,0x8
   1400014c6:	48 39 f3             	cmp    rbx,rsi
   1400014c9:	75 f5                	jne    0x1400014c0
   1400014cb:	48 8d 0d 6e ff ff ff 	lea    rcx,[rip+0xffffffffffffff6e]        # 0x140001440
   1400014d2:	48 83 c4 28          	add    rsp,0x28
   1400014d6:	5b                   	pop    rbx
   1400014d7:	5e                   	pop    rsi
   1400014d8:	e9 33 ff ff ff       	jmp    0x140001410
   1400014dd:	0f 1f 00             	nop    DWORD PTR [rax]
   1400014e0:	31 c0                	xor    eax,eax
   1400014e2:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   1400014e9:	00 00 00 00 
   1400014ed:	0f 1f 00             	nop    DWORD PTR [rax]
   1400014f0:	44 8d 40 01          	lea    r8d,[rax+0x1]
   1400014f4:	89 c1                	mov    ecx,eax
   1400014f6:	4a 83 3c c2 00       	cmp    QWORD PTR [rdx+r8*8],0x0
   1400014fb:	4c 89 c0             	mov    rax,r8
   1400014fe:	75 f0                	jne    0x1400014f0
   140001500:	eb a5                	jmp    0x1400014a7
   140001502:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140001509:	00 00 00 00 
   14000150d:	0f 1f 00             	nop    DWORD PTR [rax]
   140001510:	8b 05 1a 5b 00 00    	mov    eax,DWORD PTR [rip+0x5b1a]        # 0x140007030
   140001516:	85 c0                	test   eax,eax
   140001518:	74 06                	je     0x140001520
   14000151a:	c3                   	ret
   14000151b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   140001520:	c7 05 06 5b 00 00 01 	mov    DWORD PTR [rip+0x5b06],0x1        # 0x140007030
   140001527:	00 00 00 
   14000152a:	e9 61 ff ff ff       	jmp    0x140001490
   14000152f:	90                   	nop
   140001530:	31 c0                	xor    eax,eax
   140001532:	c3                   	ret
   140001533:	90                   	nop
   140001534:	90                   	nop
   140001535:	90                   	nop
   140001536:	90                   	nop
   140001537:	90                   	nop
   140001538:	90                   	nop
   140001539:	90                   	nop
   14000153a:	90                   	nop
   14000153b:	90                   	nop
   14000153c:	90                   	nop
   14000153d:	90                   	nop
   14000153e:	90                   	nop
   14000153f:	90                   	nop
   140001540:	83 fa 03             	cmp    edx,0x3
   140001543:	74 0b                	je     0x140001550
   140001545:	85 d2                	test   edx,edx
   140001547:	74 07                	je     0x140001550
   140001549:	c3                   	ret
   14000154a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   140001550:	e9 bb 0a 00 00       	jmp    0x140002010
   140001555:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   14000155c:	00 00 00 00 
   140001560:	56                   	push   rsi
   140001561:	53                   	push   rbx
   140001562:	48 83 ec 28          	sub    rsp,0x28
   140001566:	48 8b 05 e3 2d 00 00 	mov    rax,QWORD PTR [rip+0x2de3]        # 0x140004350
   14000156d:	83 38 02             	cmp    DWORD PTR [rax],0x2
   140001570:	74 06                	je     0x140001578
   140001572:	c7 00 02 00 00 00    	mov    DWORD PTR [rax],0x2
   140001578:	83 fa 02             	cmp    edx,0x2
   14000157b:	74 13                	je     0x140001590
   14000157d:	83 fa 01             	cmp    edx,0x1
   140001580:	74 4e                	je     0x1400015d0
   140001582:	48 83 c4 28          	add    rsp,0x28
   140001586:	5b                   	pop    rbx
   140001587:	5e                   	pop    rsi
   140001588:	c3                   	ret
   140001589:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   140001590:	48 8d 1d 09 34 00 00 	lea    rbx,[rip+0x3409]        # 0x1400049a0
   140001597:	48 8d 35 02 34 00 00 	lea    rsi,[rip+0x3402]        # 0x1400049a0
   14000159e:	48 39 f3             	cmp    rbx,rsi
   1400015a1:	74 df                	je     0x140001582
   1400015a3:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   1400015aa:	00 00 00 00 
   1400015ae:	66 90                	xchg   ax,ax
   1400015b0:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1400015b3:	48 85 c0             	test   rax,rax
   1400015b6:	74 02                	je     0x1400015ba
   1400015b8:	ff d0                	call   rax
   1400015ba:	48 83 c3 08          	add    rbx,0x8
   1400015be:	48 39 f3             	cmp    rbx,rsi
   1400015c1:	75 ed                	jne    0x1400015b0
   1400015c3:	48 83 c4 28          	add    rsp,0x28
   1400015c7:	5b                   	pop    rbx
   1400015c8:	5e                   	pop    rsi
   1400015c9:	c3                   	ret
   1400015ca:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   1400015d0:	48 83 c4 28          	add    rsp,0x28
   1400015d4:	5b                   	pop    rbx
   1400015d5:	5e                   	pop    rsi
   1400015d6:	e9 35 0a 00 00       	jmp    0x140002010
   1400015db:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   1400015e0:	31 c0                	xor    eax,eax
   1400015e2:	c3                   	ret
   1400015e3:	90                   	nop
   1400015e4:	90                   	nop
   1400015e5:	90                   	nop
   1400015e6:	90                   	nop
   1400015e7:	90                   	nop
   1400015e8:	90                   	nop
   1400015e9:	90                   	nop
   1400015ea:	90                   	nop
   1400015eb:	90                   	nop
   1400015ec:	90                   	nop
   1400015ed:	90                   	nop
   1400015ee:	90                   	nop
   1400015ef:	90                   	nop
   1400015f0:	56                   	push   rsi
   1400015f1:	53                   	push   rbx
   1400015f2:	48 83 ec 78          	sub    rsp,0x78
   1400015f6:	0f 11 74 24 40       	movups XMMWORD PTR [rsp+0x40],xmm6
   1400015fb:	0f 11 7c 24 50       	movups XMMWORD PTR [rsp+0x50],xmm7
   140001600:	44 0f 11 44 24 60    	movups XMMWORD PTR [rsp+0x60],xmm8
   140001606:	83 39 06             	cmp    DWORD PTR [rcx],0x6
   140001609:	0f 87 cd 00 00 00    	ja     0x1400016dc
   14000160f:	8b 01                	mov    eax,DWORD PTR [rcx]
   140001611:	48 8d 15 8c 2b 00 00 	lea    rdx,[rip+0x2b8c]        # 0x1400041a4
   140001618:	48 63 04 82          	movsxd rax,DWORD PTR [rdx+rax*4]
   14000161c:	48 01 d0             	add    rax,rdx
   14000161f:	ff e0                	jmp    rax
   140001621:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   140001628:	48 8d 1d 70 2a 00 00 	lea    rbx,[rip+0x2a70]        # 0x14000409f
   14000162f:	f2 44 0f 10 41 20    	movsd  xmm8,QWORD PTR [rcx+0x20]
   140001635:	f2 0f 10 79 18       	movsd  xmm7,QWORD PTR [rcx+0x18]
   14000163a:	f2 0f 10 71 10       	movsd  xmm6,QWORD PTR [rcx+0x10]
   14000163f:	48 8b 71 08          	mov    rsi,QWORD PTR [rcx+0x8]
   140001643:	b9 02 00 00 00       	mov    ecx,0x2
   140001648:	e8 d3 0f 00 00       	call   0x140002620
   14000164d:	f2 44 0f 11 44 24 30 	movsd  QWORD PTR [rsp+0x30],xmm8
   140001654:	49 89 d8             	mov    r8,rbx
   140001657:	48 8d 15 1a 2b 00 00 	lea    rdx,[rip+0x2b1a]        # 0x140004178
   14000165e:	f2 0f 11 7c 24 28    	movsd  QWORD PTR [rsp+0x28],xmm7
   140001664:	48 89 c1             	mov    rcx,rax
   140001667:	49 89 f1             	mov    r9,rsi
   14000166a:	f2 0f 11 74 24 20    	movsd  QWORD PTR [rsp+0x20],xmm6
   140001670:	e8 2b 10 00 00       	call   0x1400026a0
   140001675:	90                   	nop
   140001676:	0f 10 74 24 40       	movups xmm6,XMMWORD PTR [rsp+0x40]
   14000167b:	0f 10 7c 24 50       	movups xmm7,XMMWORD PTR [rsp+0x50]
   140001680:	31 c0                	xor    eax,eax
   140001682:	44 0f 10 44 24 60    	movups xmm8,XMMWORD PTR [rsp+0x60]
   140001688:	48 83 c4 78          	add    rsp,0x78
   14000168c:	5b                   	pop    rbx
   14000168d:	5e                   	pop    rsi
   14000168e:	c3                   	ret
   14000168f:	90                   	nop
   140001690:	48 8d 1d e9 29 00 00 	lea    rbx,[rip+0x29e9]        # 0x140004080
   140001697:	eb 96                	jmp    0x14000162f
   140001699:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1400016a0:	48 8d 1d 39 2a 00 00 	lea    rbx,[rip+0x2a39]        # 0x1400040e0
   1400016a7:	eb 86                	jmp    0x14000162f
   1400016a9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1400016b0:	48 8d 1d 09 2a 00 00 	lea    rbx,[rip+0x2a09]        # 0x1400040c0
   1400016b7:	e9 73 ff ff ff       	jmp    0x14000162f
   1400016bc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1400016c0:	48 8d 1d 69 2a 00 00 	lea    rbx,[rip+0x2a69]        # 0x140004130
   1400016c7:	e9 63 ff ff ff       	jmp    0x14000162f
   1400016cc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1400016d0:	48 8d 1d 31 2a 00 00 	lea    rbx,[rip+0x2a31]        # 0x140004108
   1400016d7:	e9 53 ff ff ff       	jmp    0x14000162f
   1400016dc:	48 8d 1d 83 2a 00 00 	lea    rbx,[rip+0x2a83]        # 0x140004166
   1400016e3:	e9 47 ff ff ff       	jmp    0x14000162f
   1400016e8:	90                   	nop
   1400016e9:	90                   	nop
   1400016ea:	90                   	nop
   1400016eb:	90                   	nop
   1400016ec:	90                   	nop
   1400016ed:	90                   	nop
   1400016ee:	90                   	nop
   1400016ef:	90                   	nop
   1400016f0:	56                   	push   rsi
   1400016f1:	53                   	push   rbx
   1400016f2:	48 83 ec 38          	sub    rsp,0x38
   1400016f6:	48 89 cb             	mov    rbx,rcx
   1400016f9:	48 8d 44 24 58       	lea    rax,[rsp+0x58]
   1400016fe:	b9 02 00 00 00       	mov    ecx,0x2
   140001703:	4c 89 44 24 60       	mov    QWORD PTR [rsp+0x60],r8
   140001708:	4c 89 4c 24 68       	mov    QWORD PTR [rsp+0x68],r9
   14000170d:	48 89 54 24 58       	mov    QWORD PTR [rsp+0x58],rdx
   140001712:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
   140001717:	e8 04 0f 00 00       	call   0x140002620
   14000171c:	48 8d 15 9d 2a 00 00 	lea    rdx,[rip+0x2a9d]        # 0x1400041c0
   140001723:	48 89 c1             	mov    rcx,rax
   140001726:	e8 75 0f 00 00       	call   0x1400026a0
   14000172b:	48 8b 74 24 28       	mov    rsi,QWORD PTR [rsp+0x28]
   140001730:	b9 02 00 00 00       	mov    ecx,0x2
   140001735:	e8 e6 0e 00 00       	call   0x140002620
   14000173a:	48 89 da             	mov    rdx,rbx
   14000173d:	48 89 c1             	mov    rcx,rax
   140001740:	49 89 f0             	mov    r8,rsi
   140001743:	e8 98 0f 00 00       	call   0x1400026e0
   140001748:	e8 33 0f 00 00       	call   0x140002680
   14000174d:	90                   	nop
   14000174e:	66 90                	xchg   ax,ax
   140001750:	57                   	push   rdi
   140001751:	56                   	push   rsi
   140001752:	53                   	push   rbx
   140001753:	48 83 ec 50          	sub    rsp,0x50
   140001757:	48 63 35 46 59 00 00 	movsxd rsi,DWORD PTR [rip+0x5946]        # 0x1400070a4
   14000175e:	48 89 cb             	mov    rbx,rcx
   140001761:	85 f6                	test   esi,esi
   140001763:	0f 8e 17 01 00 00    	jle    0x140001880
   140001769:	48 8b 05 38 59 00 00 	mov    rax,QWORD PTR [rip+0x5938]        # 0x1400070a8
   140001770:	45 31 c9             	xor    r9d,r9d
   140001773:	48 83 c0 18          	add    rax,0x18
   140001777:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   14000177e:	00 00 
   140001780:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   140001783:	4c 39 c3             	cmp    rbx,r8
   140001786:	72 13                	jb     0x14000179b
   140001788:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
   14000178c:	8b 52 08             	mov    edx,DWORD PTR [rdx+0x8]
   14000178f:	49 01 d0             	add    r8,rdx
   140001792:	4c 39 c3             	cmp    rbx,r8
   140001795:	0f 82 8a 00 00 00    	jb     0x140001825
   14000179b:	41 83 c1 01          	add    r9d,0x1
   14000179f:	48 83 c0 28          	add    rax,0x28
   1400017a3:	41 39 f1             	cmp    r9d,esi
   1400017a6:	75 d8                	jne    0x140001780
   1400017a8:	48 89 d9             	mov    rcx,rbx
   1400017ab:	e8 a0 0a 00 00       	call   0x140002250
   1400017b0:	48 89 c7             	mov    rdi,rax
   1400017b3:	48 85 c0             	test   rax,rax
   1400017b6:	0f 84 e6 00 00 00    	je     0x1400018a2
   1400017bc:	48 8b 05 e5 58 00 00 	mov    rax,QWORD PTR [rip+0x58e5]        # 0x1400070a8
   1400017c3:	48 8d 1c b6          	lea    rbx,[rsi+rsi*4]
   1400017c7:	48 c1 e3 03          	shl    rbx,0x3
   1400017cb:	48 01 d8             	add    rax,rbx
   1400017ce:	48 89 78 20          	mov    QWORD PTR [rax+0x20],rdi
   1400017d2:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
   1400017d8:	e8 b3 0b 00 00       	call   0x140002390
   1400017dd:	8b 57 0c             	mov    edx,DWORD PTR [rdi+0xc]
   1400017e0:	41 b8 30 00 00 00    	mov    r8d,0x30
   1400017e6:	48 8d 0c 10          	lea    rcx,[rax+rdx*1]
   1400017ea:	48 8b 05 b7 58 00 00 	mov    rax,QWORD PTR [rip+0x58b7]        # 0x1400070a8
   1400017f1:	48 8d 54 24 20       	lea    rdx,[rsp+0x20]
   1400017f6:	48 89 4c 18 18       	mov    QWORD PTR [rax+rbx*1+0x18],rcx
   1400017fb:	ff 15 a7 69 00 00    	call   QWORD PTR [rip+0x69a7]        # 0x1400081a8
   140001801:	48 85 c0             	test   rax,rax
   140001804:	0f 84 7d 00 00 00    	je     0x140001887
   14000180a:	8b 44 24 44          	mov    eax,DWORD PTR [rsp+0x44]
   14000180e:	8d 50 fc             	lea    edx,[rax-0x4]
   140001811:	83 e2 fb             	and    edx,0xfffffffb
   140001814:	74 08                	je     0x14000181e
   140001816:	8d 50 c0             	lea    edx,[rax-0x40]
   140001819:	83 e2 bf             	and    edx,0xffffffbf
   14000181c:	75 12                	jne    0x140001830
   14000181e:	83 05 7f 58 00 00 01 	add    DWORD PTR [rip+0x587f],0x1        # 0x1400070a4
   140001825:	48 83 c4 50          	add    rsp,0x50
   140001829:	5b                   	pop    rbx
   14000182a:	5e                   	pop    rsi
   14000182b:	5f                   	pop    rdi
   14000182c:	c3                   	ret
   14000182d:	0f 1f 00             	nop    DWORD PTR [rax]
   140001830:	83 f8 02             	cmp    eax,0x2
   140001833:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
   140001838:	48 8b 54 24 38       	mov    rdx,QWORD PTR [rsp+0x38]
   14000183d:	41 b8 40 00 00 00    	mov    r8d,0x40
   140001843:	b8 04 00 00 00       	mov    eax,0x4
   140001848:	44 0f 44 c0          	cmove  r8d,eax
   14000184c:	48 03 1d 55 58 00 00 	add    rbx,QWORD PTR [rip+0x5855]        # 0x1400070a8
   140001853:	48 89 4b 08          	mov    QWORD PTR [rbx+0x8],rcx
   140001857:	49 89 d9             	mov    r9,rbx
   14000185a:	48 89 53 10          	mov    QWORD PTR [rbx+0x10],rdx
   14000185e:	ff 15 3c 69 00 00    	call   QWORD PTR [rip+0x693c]        # 0x1400081a0
   140001864:	85 c0                	test   eax,eax
   140001866:	75 b6                	jne    0x14000181e
   140001868:	ff 15 02 69 00 00    	call   QWORD PTR [rip+0x6902]        # 0x140008170
   14000186e:	48 8d 0d c3 29 00 00 	lea    rcx,[rip+0x29c3]        # 0x140004238
   140001875:	89 c2                	mov    edx,eax
   140001877:	e8 74 fe ff ff       	call   0x1400016f0
   14000187c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140001880:	31 f6                	xor    esi,esi
   140001882:	e9 21 ff ff ff       	jmp    0x1400017a8
   140001887:	48 8b 05 1a 58 00 00 	mov    rax,QWORD PTR [rip+0x581a]        # 0x1400070a8
   14000188e:	8b 57 08             	mov    edx,DWORD PTR [rdi+0x8]
   140001891:	48 8d 0d 68 29 00 00 	lea    rcx,[rip+0x2968]        # 0x140004200
   140001898:	4c 8b 44 18 18       	mov    r8,QWORD PTR [rax+rbx*1+0x18]
   14000189d:	e8 4e fe ff ff       	call   0x1400016f0
   1400018a2:	48 89 da             	mov    rdx,rbx
   1400018a5:	48 8d 0d 34 29 00 00 	lea    rcx,[rip+0x2934]        # 0x1400041e0
   1400018ac:	e8 3f fe ff ff       	call   0x1400016f0
   1400018b1:	90                   	nop
   1400018b2:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   1400018b9:	00 00 00 00 
   1400018bd:	0f 1f 00             	nop    DWORD PTR [rax]
   1400018c0:	55                   	push   rbp
   1400018c1:	41 57                	push   r15
   1400018c3:	41 56                	push   r14
   1400018c5:	41 55                	push   r13
   1400018c7:	41 54                	push   r12
   1400018c9:	57                   	push   rdi
   1400018ca:	56                   	push   rsi
   1400018cb:	53                   	push   rbx
   1400018cc:	48 83 ec 48          	sub    rsp,0x48
   1400018d0:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   1400018d5:	8b 35 c5 57 00 00    	mov    esi,DWORD PTR [rip+0x57c5]        # 0x1400070a0
   1400018db:	85 f6                	test   esi,esi
   1400018dd:	74 11                	je     0x1400018f0
   1400018df:	48 8d 65 08          	lea    rsp,[rbp+0x8]
   1400018e3:	5b                   	pop    rbx
   1400018e4:	5e                   	pop    rsi
   1400018e5:	5f                   	pop    rdi
   1400018e6:	41 5c                	pop    r12
   1400018e8:	41 5d                	pop    r13
   1400018ea:	41 5e                	pop    r14
   1400018ec:	41 5f                	pop    r15
   1400018ee:	5d                   	pop    rbp
   1400018ef:	c3                   	ret
   1400018f0:	c7 05 a6 57 00 00 01 	mov    DWORD PTR [rip+0x57a6],0x1        # 0x1400070a0
   1400018f7:	00 00 00 
   1400018fa:	e8 d1 09 00 00       	call   0x1400022d0
   1400018ff:	48 98                	cdqe
   140001901:	48 8d 04 80          	lea    rax,[rax+rax*4]
   140001905:	48 8d 04 c5 0f 00 00 	lea    rax,[rax*8+0xf]
   14000190c:	00 
   14000190d:	48 83 e0 f0          	and    rax,0xfffffffffffffff0
   140001911:	e8 1a 0c 00 00       	call   0x140002530
   140001916:	48 8b 3d 73 2a 00 00 	mov    rdi,QWORD PTR [rip+0x2a73]        # 0x140004390
   14000191d:	48 8b 1d 7c 2a 00 00 	mov    rbx,QWORD PTR [rip+0x2a7c]        # 0x1400043a0
   140001924:	48 29 c4             	sub    rsp,rax
   140001927:	c7 05 73 57 00 00 00 	mov    DWORD PTR [rip+0x5773],0x0        # 0x1400070a4
   14000192e:	00 00 00 
   140001931:	48 8d 44 24 30       	lea    rax,[rsp+0x30]
   140001936:	48 89 05 6b 57 00 00 	mov    QWORD PTR [rip+0x576b],rax        # 0x1400070a8
   14000193d:	48 89 f8             	mov    rax,rdi
   140001940:	48 29 d8             	sub    rax,rbx
   140001943:	48 83 f8 07          	cmp    rax,0x7
   140001947:	7e 96                	jle    0x1400018df
   140001949:	48 83 f8 0b          	cmp    rax,0xb
   14000194d:	0f 8f 85 01 00 00    	jg     0x140001ad8
   140001953:	8b 13                	mov    edx,DWORD PTR [rbx]
   140001955:	85 d2                	test   edx,edx
   140001957:	0f 85 90 01 00 00    	jne    0x140001aed
   14000195d:	8b 43 04             	mov    eax,DWORD PTR [rbx+0x4]
   140001960:	85 c0                	test   eax,eax
   140001962:	0f 85 85 01 00 00    	jne    0x140001aed
   140001968:	8b 53 08             	mov    edx,DWORD PTR [rbx+0x8]
   14000196b:	83 fa 01             	cmp    edx,0x1
   14000196e:	0f 85 dd 02 00 00    	jne    0x140001c51
   140001974:	48 83 c3 0c          	add    rbx,0xc
   140001978:	4c 8b 3d 01 2a 00 00 	mov    r15,QWORD PTR [rip+0x2a01]        # 0x140004380
   14000197f:	41 bd ff ff ff ff    	mov    r13d,0xffffffff
   140001985:	48 39 fb             	cmp    rbx,rdi
   140001988:	72 7c                	jb     0x140001a06
   14000198a:	e9 50 ff ff ff       	jmp    0x1400018df
   14000198f:	90                   	nop
   140001990:	83 fa 08             	cmp    edx,0x8
   140001993:	0f 84 27 02 00 00    	je     0x140001bc0
   140001999:	83 fa 10             	cmp    edx,0x10
   14000199c:	0f 85 87 02 00 00    	jne    0x140001c29
   1400019a2:	41 0f b7 04 24       	movzx  eax,WORD PTR [r12]
   1400019a7:	41 81 e0 c0 00 00 00 	and    r8d,0xc0
   1400019ae:	66 85 c0             	test   ax,ax
   1400019b1:	79 06                	jns    0x1400019b9
   1400019b3:	48 0d 00 00 ff ff    	or     rax,0xffffffffffff0000
   1400019b9:	4c 29 d0             	sub    rax,r10
   1400019bc:	4c 01 c8             	add    rax,r9
   1400019bf:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
   1400019c3:	45 85 c0             	test   r8d,r8d
   1400019c6:	75 18                	jne    0x1400019e0
   1400019c8:	48 3d ff ff 00 00    	cmp    rax,0xffff
   1400019ce:	0f 8f 69 02 00 00    	jg     0x140001c3d
   1400019d4:	48 3d 00 80 ff ff    	cmp    rax,0xffffffffffff8000
   1400019da:	0f 8c 5d 02 00 00    	jl     0x140001c3d
   1400019e0:	4c 89 e1             	mov    rcx,r12
   1400019e3:	4c 8d 75 f8          	lea    r14,[rbp-0x8]
   1400019e7:	e8 64 fd ff ff       	call   0x140001750
   1400019ec:	41 b8 02 00 00 00    	mov    r8d,0x2
   1400019f2:	4c 89 f2             	mov    rdx,r14
   1400019f5:	4c 89 e1             	mov    rcx,r12
   1400019f8:	e8 bb 0c 00 00       	call   0x1400026b8
   1400019fd:	48 83 c3 0c          	add    rbx,0xc
   140001a01:	48 39 fb             	cmp    rbx,rdi
   140001a04:	73 7a                	jae    0x140001a80
   140001a06:	44 8b 13             	mov    r10d,DWORD PTR [rbx]
   140001a09:	44 8b 43 08          	mov    r8d,DWORD PTR [rbx+0x8]
   140001a0d:	8b 4b 04             	mov    ecx,DWORD PTR [rbx+0x4]
   140001a10:	4d 01 fa             	add    r10,r15
   140001a13:	41 0f b6 d0          	movzx  edx,r8b
   140001a17:	4d 8b 0a             	mov    r9,QWORD PTR [r10]
   140001a1a:	4e 8d 24 39          	lea    r12,[rcx+r15*1]
   140001a1e:	83 fa 20             	cmp    edx,0x20
   140001a21:	0f 84 29 01 00 00    	je     0x140001b50
   140001a27:	0f 86 63 ff ff ff    	jbe    0x140001990
   140001a2d:	83 fa 40             	cmp    edx,0x40
   140001a30:	0f 85 f3 01 00 00    	jne    0x140001c29
   140001a36:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   140001a3a:	4c 29 d0             	sub    rax,r10
   140001a3d:	4c 01 c8             	add    rax,r9
   140001a40:	41 81 e0 c0 00 00 00 	and    r8d,0xc0
   140001a47:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
   140001a4b:	75 09                	jne    0x140001a56
   140001a4d:	48 85 c0             	test   rax,rax
   140001a50:	0f 89 e7 01 00 00    	jns    0x140001c3d
   140001a56:	4c 89 e1             	mov    rcx,r12
   140001a59:	4c 8d 75 f8          	lea    r14,[rbp-0x8]
   140001a5d:	48 83 c3 0c          	add    rbx,0xc
   140001a61:	e8 ea fc ff ff       	call   0x140001750
   140001a66:	41 b8 08 00 00 00    	mov    r8d,0x8
   140001a6c:	4c 89 f2             	mov    rdx,r14
   140001a6f:	4c 89 e1             	mov    rcx,r12
   140001a72:	e8 41 0c 00 00       	call   0x1400026b8
   140001a77:	48 39 fb             	cmp    rbx,rdi
   140001a7a:	72 8a                	jb     0x140001a06
   140001a7c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140001a80:	8b 05 1e 56 00 00    	mov    eax,DWORD PTR [rip+0x561e]        # 0x1400070a4
   140001a86:	85 c0                	test   eax,eax
   140001a88:	0f 8e 51 fe ff ff    	jle    0x1400018df
   140001a8e:	48 8b 3d 0b 67 00 00 	mov    rdi,QWORD PTR [rip+0x670b]        # 0x1400081a0
   140001a95:	31 db                	xor    ebx,ebx
   140001a97:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   140001a9e:	00 00 
   140001aa0:	48 8b 05 01 56 00 00 	mov    rax,QWORD PTR [rip+0x5601]        # 0x1400070a8
   140001aa7:	48 01 d8             	add    rax,rbx
   140001aaa:	44 8b 00             	mov    r8d,DWORD PTR [rax]
   140001aad:	45 85 c0             	test   r8d,r8d
   140001ab0:	74 0d                	je     0x140001abf
   140001ab2:	48 8b 50 10          	mov    rdx,QWORD PTR [rax+0x10]
   140001ab6:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   140001aba:	4d 89 f1             	mov    r9,r14
   140001abd:	ff d7                	call   rdi
   140001abf:	83 c6 01             	add    esi,0x1
   140001ac2:	48 83 c3 28          	add    rbx,0x28
   140001ac6:	3b 35 d8 55 00 00    	cmp    esi,DWORD PTR [rip+0x55d8]        # 0x1400070a4
   140001acc:	7c d2                	jl     0x140001aa0
   140001ace:	e9 0c fe ff ff       	jmp    0x1400018df
   140001ad3:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   140001ad8:	44 8b 0b             	mov    r9d,DWORD PTR [rbx]
   140001adb:	45 85 c9             	test   r9d,r9d
   140001ade:	75 0d                	jne    0x140001aed
   140001ae0:	44 8b 43 04          	mov    r8d,DWORD PTR [rbx+0x4]
   140001ae4:	45 85 c0             	test   r8d,r8d
   140001ae7:	0f 84 28 01 00 00    	je     0x140001c15
   140001aed:	48 39 fb             	cmp    rbx,rdi
   140001af0:	0f 83 e9 fd ff ff    	jae    0x1400018df
   140001af6:	4c 8b 2d 83 28 00 00 	mov    r13,QWORD PTR [rip+0x2883]        # 0x140004380
   140001afd:	4c 8d 75 f8          	lea    r14,[rbp-0x8]
   140001b01:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140001b08:	00 00 00 00 
   140001b0c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140001b10:	44 8b 63 04          	mov    r12d,DWORD PTR [rbx+0x4]
   140001b14:	8b 03                	mov    eax,DWORD PTR [rbx]
   140001b16:	48 83 c3 08          	add    rbx,0x8
   140001b1a:	4d 01 ec             	add    r12,r13
   140001b1d:	41 03 04 24          	add    eax,DWORD PTR [r12]
   140001b21:	4c 89 e1             	mov    rcx,r12
   140001b24:	89 45 f8             	mov    DWORD PTR [rbp-0x8],eax
   140001b27:	e8 24 fc ff ff       	call   0x140001750
   140001b2c:	41 b8 04 00 00 00    	mov    r8d,0x4
   140001b32:	4c 89 f2             	mov    rdx,r14
   140001b35:	4c 89 e1             	mov    rcx,r12
   140001b38:	e8 7b 0b 00 00       	call   0x1400026b8
   140001b3d:	48 39 fb             	cmp    rbx,rdi
   140001b40:	72 ce                	jb     0x140001b10
   140001b42:	e9 39 ff ff ff       	jmp    0x140001a80
   140001b47:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   140001b4e:	00 00 
   140001b50:	41 8b 04 24          	mov    eax,DWORD PTR [r12]
   140001b54:	41 81 e0 c0 00 00 00 	and    r8d,0xc0
   140001b5b:	85 c0                	test   eax,eax
   140001b5d:	79 0d                	jns    0x140001b6c
   140001b5f:	48 b9 00 00 00 00 ff 	movabs rcx,0xffffffff00000000
   140001b66:	ff ff ff 
   140001b69:	48 09 c8             	or     rax,rcx
   140001b6c:	4c 29 d0             	sub    rax,r10
   140001b6f:	4c 01 c8             	add    rax,r9
   140001b72:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
   140001b76:	45 85 c0             	test   r8d,r8d
   140001b79:	75 1c                	jne    0x140001b97
   140001b7b:	4c 39 e8             	cmp    rax,r13
   140001b7e:	0f 8f b9 00 00 00    	jg     0x140001c3d
   140001b84:	48 b9 ff ff ff 7f ff 	movabs rcx,0xffffffff7fffffff
   140001b8b:	ff ff ff 
   140001b8e:	48 39 c8             	cmp    rax,rcx
   140001b91:	0f 8e a6 00 00 00    	jle    0x140001c3d
   140001b97:	4c 89 e1             	mov    rcx,r12
   140001b9a:	4c 8d 75 f8          	lea    r14,[rbp-0x8]
   140001b9e:	e8 ad fb ff ff       	call   0x140001750
   140001ba3:	41 b8 04 00 00 00    	mov    r8d,0x4
   140001ba9:	4c 89 f2             	mov    rdx,r14
   140001bac:	4c 89 e1             	mov    rcx,r12
   140001baf:	e8 04 0b 00 00       	call   0x1400026b8
   140001bb4:	e9 44 fe ff ff       	jmp    0x1400019fd
   140001bb9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   140001bc0:	41 0f b6 04 24       	movzx  eax,BYTE PTR [r12]
   140001bc5:	41 81 e0 c0 00 00 00 	and    r8d,0xc0
   140001bcc:	84 c0                	test   al,al
   140001bce:	79 06                	jns    0x140001bd6
   140001bd0:	48 0d 00 ff ff ff    	or     rax,0xffffffffffffff00
   140001bd6:	4c 29 d0             	sub    rax,r10
   140001bd9:	4c 01 c8             	add    rax,r9
   140001bdc:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
   140001be0:	45 85 c0             	test   r8d,r8d
   140001be3:	75 0e                	jne    0x140001bf3
   140001be5:	48 3d ff 00 00 00    	cmp    rax,0xff
   140001beb:	7f 50                	jg     0x140001c3d
   140001bed:	48 83 f8 80          	cmp    rax,0xffffffffffffff80
   140001bf1:	7c 4a                	jl     0x140001c3d
   140001bf3:	4c 89 e1             	mov    rcx,r12
   140001bf6:	4c 8d 75 f8          	lea    r14,[rbp-0x8]
   140001bfa:	e8 51 fb ff ff       	call   0x140001750
   140001bff:	41 b8 01 00 00 00    	mov    r8d,0x1
   140001c05:	4c 89 f2             	mov    rdx,r14
   140001c08:	4c 89 e1             	mov    rcx,r12
   140001c0b:	e8 a8 0a 00 00       	call   0x1400026b8
   140001c10:	e9 e8 fd ff ff       	jmp    0x1400019fd
   140001c15:	8b 4b 08             	mov    ecx,DWORD PTR [rbx+0x8]
   140001c18:	85 c9                	test   ecx,ecx
   140001c1a:	0f 85 48 fd ff ff    	jne    0x140001968
   140001c20:	48 83 c3 0c          	add    rbx,0xc
   140001c24:	e9 2a fd ff ff       	jmp    0x140001953
   140001c29:	48 8d 0d 68 26 00 00 	lea    rcx,[rip+0x2668]        # 0x140004298
   140001c30:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
   140001c37:	00 
   140001c38:	e8 b3 fa ff ff       	call   0x1400016f0
   140001c3d:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   140001c42:	4d 89 e0             	mov    r8,r12
   140001c45:	48 8d 0d 7c 26 00 00 	lea    rcx,[rip+0x267c]        # 0x1400042c8
   140001c4c:	e8 9f fa ff ff       	call   0x1400016f0
   140001c51:	48 8d 0d 08 26 00 00 	lea    rcx,[rip+0x2608]        # 0x140004260
   140001c58:	e8 93 fa ff ff       	call   0x1400016f0
   140001c5d:	90                   	nop
   140001c5e:	90                   	nop
   140001c5f:	90                   	nop
   140001c60:	48 83 ec 58          	sub    rsp,0x58
   140001c64:	48 8b 05 45 54 00 00 	mov    rax,QWORD PTR [rip+0x5445]        # 0x1400070b0
   140001c6b:	66 0f 14 d3          	unpcklpd xmm2,xmm3
   140001c6f:	48 85 c0             	test   rax,rax
   140001c72:	74 25                	je     0x140001c99
   140001c74:	f2 0f 10 84 24 80 00 	movsd  xmm0,QWORD PTR [rsp+0x80]
   140001c7b:	00 00 
   140001c7d:	89 4c 24 20          	mov    DWORD PTR [rsp+0x20],ecx
   140001c81:	48 8d 4c 24 20       	lea    rcx,[rsp+0x20]
   140001c86:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
   140001c8b:	0f 11 54 24 30       	movups XMMWORD PTR [rsp+0x30],xmm2
   140001c90:	f2 0f 11 44 24 40    	movsd  QWORD PTR [rsp+0x40],xmm0
   140001c96:	ff d0                	call   rax
   140001c98:	90                   	nop
   140001c99:	48 83 c4 58          	add    rsp,0x58
   140001c9d:	c3                   	ret
   140001c9e:	66 90                	xchg   ax,ax
   140001ca0:	48 89 0d 09 54 00 00 	mov    QWORD PTR [rip+0x5409],rcx        # 0x1400070b0
   140001ca7:	e9 b4 09 00 00       	jmp    0x140002660
   140001cac:	90                   	nop
   140001cad:	90                   	nop
   140001cae:	90                   	nop
   140001caf:	90                   	nop
   140001cb0:	53                   	push   rbx
   140001cb1:	48 83 ec 20          	sub    rsp,0x20
   140001cb5:	48 8b 11             	mov    rdx,QWORD PTR [rcx]
   140001cb8:	8b 02                	mov    eax,DWORD PTR [rdx]
   140001cba:	48 89 cb             	mov    rbx,rcx
   140001cbd:	89 c1                	mov    ecx,eax
   140001cbf:	81 e1 ff ff ff 20    	and    ecx,0x20ffffff
   140001cc5:	81 f9 43 43 47 20    	cmp    ecx,0x20474343
   140001ccb:	0f 84 8f 00 00 00    	je     0x140001d60
   140001cd1:	3d 96 00 00 c0       	cmp    eax,0xc0000096
   140001cd6:	77 47                	ja     0x140001d1f
   140001cd8:	3d 8b 00 00 c0       	cmp    eax,0xc000008b
   140001cdd:	76 61                	jbe    0x140001d40
   140001cdf:	05 73 ff ff 3f       	add    eax,0x3fffff73
   140001ce4:	83 f8 09             	cmp    eax,0x9
   140001ce7:	77 6b                	ja     0x140001d54
   140001ce9:	48 8d 15 30 26 00 00 	lea    rdx,[rip+0x2630]        # 0x140004320
   140001cf0:	48 63 04 82          	movsxd rax,DWORD PTR [rdx+rax*4]
   140001cf4:	48 01 d0             	add    rax,rdx
   140001cf7:	ff e0                	jmp    rax
   140001cf9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   140001d00:	31 d2                	xor    edx,edx
   140001d02:	b9 08 00 00 00       	mov    ecx,0x8
   140001d07:	e8 bc 09 00 00       	call   0x1400026c8
   140001d0c:	48 83 f8 01          	cmp    rax,0x1
   140001d10:	0f 84 3e 01 00 00    	je     0x140001e54
   140001d16:	48 85 c0             	test   rax,rax
   140001d19:	0f 85 01 01 00 00    	jne    0x140001e20
   140001d1f:	48 8b 05 aa 53 00 00 	mov    rax,QWORD PTR [rip+0x53aa]        # 0x1400070d0
   140001d26:	48 85 c0             	test   rax,rax
   140001d29:	74 45                	je     0x140001d70
   140001d2b:	48 89 d9             	mov    rcx,rbx
   140001d2e:	48 83 c4 20          	add    rsp,0x20
   140001d32:	5b                   	pop    rbx
   140001d33:	48 ff e0             	rex.W jmp rax
   140001d36:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   140001d3d:	00 00 00 
   140001d40:	3d 05 00 00 c0       	cmp    eax,0xc0000005
   140001d45:	0f 84 a5 00 00 00    	je     0x140001df0
   140001d4b:	77 33                	ja     0x140001d80
   140001d4d:	3d 02 00 00 80       	cmp    eax,0x80000002
   140001d52:	75 cb                	jne    0x140001d1f
   140001d54:	b8 ff ff ff ff       	mov    eax,0xffffffff
   140001d59:	48 83 c4 20          	add    rsp,0x20
   140001d5d:	5b                   	pop    rbx
   140001d5e:	c3                   	ret
   140001d5f:	90                   	nop
   140001d60:	f6 42 04 01          	test   BYTE PTR [rdx+0x4],0x1
   140001d64:	0f 85 67 ff ff ff    	jne    0x140001cd1
   140001d6a:	eb e8                	jmp    0x140001d54
   140001d6c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140001d70:	31 c0                	xor    eax,eax
   140001d72:	48 83 c4 20          	add    rsp,0x20
   140001d76:	5b                   	pop    rbx
   140001d77:	c3                   	ret
   140001d78:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   140001d7f:	00 
   140001d80:	3d 08 00 00 c0       	cmp    eax,0xc0000008
   140001d85:	74 cd                	je     0x140001d54
   140001d87:	3d 1d 00 00 c0       	cmp    eax,0xc000001d
   140001d8c:	75 91                	jne    0x140001d1f
   140001d8e:	31 d2                	xor    edx,edx
   140001d90:	b9 04 00 00 00       	mov    ecx,0x4
   140001d95:	e8 2e 09 00 00       	call   0x1400026c8
   140001d9a:	48 83 f8 01          	cmp    rax,0x1
   140001d9e:	0f 84 9c 00 00 00    	je     0x140001e40
   140001da4:	48 85 c0             	test   rax,rax
   140001da7:	0f 84 72 ff ff ff    	je     0x140001d1f
   140001dad:	b9 04 00 00 00       	mov    ecx,0x4
   140001db2:	ff d0                	call   rax
   140001db4:	eb 9e                	jmp    0x140001d54
   140001db6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   140001dbd:	00 00 00 
   140001dc0:	31 d2                	xor    edx,edx
   140001dc2:	b9 08 00 00 00       	mov    ecx,0x8
   140001dc7:	e8 fc 08 00 00       	call   0x1400026c8
   140001dcc:	48 83 f8 01          	cmp    rax,0x1
   140001dd0:	0f 85 40 ff ff ff    	jne    0x140001d16
   140001dd6:	ba 01 00 00 00       	mov    edx,0x1
   140001ddb:	b9 08 00 00 00       	mov    ecx,0x8
   140001de0:	e8 e3 08 00 00       	call   0x1400026c8
   140001de5:	e9 6a ff ff ff       	jmp    0x140001d54
   140001dea:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   140001df0:	31 d2                	xor    edx,edx
   140001df2:	b9 0b 00 00 00       	mov    ecx,0xb
   140001df7:	e8 cc 08 00 00       	call   0x1400026c8
   140001dfc:	48 83 f8 01          	cmp    rax,0x1
   140001e00:	74 2a                	je     0x140001e2c
   140001e02:	48 85 c0             	test   rax,rax
   140001e05:	0f 84 14 ff ff ff    	je     0x140001d1f
   140001e0b:	b9 0b 00 00 00       	mov    ecx,0xb
   140001e10:	ff d0                	call   rax
   140001e12:	e9 3d ff ff ff       	jmp    0x140001d54
   140001e17:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   140001e1e:	00 00 
   140001e20:	b9 08 00 00 00       	mov    ecx,0x8
   140001e25:	ff d0                	call   rax
   140001e27:	e9 28 ff ff ff       	jmp    0x140001d54
   140001e2c:	ba 01 00 00 00       	mov    edx,0x1
   140001e31:	b9 0b 00 00 00       	mov    ecx,0xb
   140001e36:	e8 8d 08 00 00       	call   0x1400026c8
   140001e3b:	e9 14 ff ff ff       	jmp    0x140001d54
   140001e40:	ba 01 00 00 00       	mov    edx,0x1
   140001e45:	b9 04 00 00 00       	mov    ecx,0x4
   140001e4a:	e8 79 08 00 00       	call   0x1400026c8
   140001e4f:	e9 00 ff ff ff       	jmp    0x140001d54
   140001e54:	ba 01 00 00 00       	mov    edx,0x1
   140001e59:	b9 08 00 00 00       	mov    ecx,0x8
   140001e5e:	e8 65 08 00 00       	call   0x1400026c8
   140001e63:	e8 b8 02 00 00       	call   0x140002120
   140001e68:	e9 e7 fe ff ff       	jmp    0x140001d54
   140001e6d:	90                   	nop
   140001e6e:	90                   	nop
   140001e6f:	90                   	nop
   140001e70:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   140001e77:	00 00 00 
   140001e7a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   140001e80:	41 54                	push   r12
   140001e82:	55                   	push   rbp
   140001e83:	57                   	push   rdi
   140001e84:	56                   	push   rsi
   140001e85:	53                   	push   rbx
   140001e86:	48 83 ec 20          	sub    rsp,0x20
   140001e8a:	4c 8d 25 6f 52 00 00 	lea    r12,[rip+0x526f]        # 0x140007100
   140001e91:	4c 89 e1             	mov    rcx,r12
   140001e94:	ff 15 ce 62 00 00    	call   QWORD PTR [rip+0x62ce]        # 0x140008168
   140001e9a:	48 8b 1d 3f 52 00 00 	mov    rbx,QWORD PTR [rip+0x523f]        # 0x1400070e0
   140001ea1:	48 85 db             	test   rbx,rbx
   140001ea4:	74 3e                	je     0x140001ee4
   140001ea6:	48 8b 2d eb 62 00 00 	mov    rbp,QWORD PTR [rip+0x62eb]        # 0x140008198
   140001ead:	48 8b 3d bc 62 00 00 	mov    rdi,QWORD PTR [rip+0x62bc]        # 0x140008170
   140001eb4:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140001ebb:	00 00 00 00 
   140001ebf:	90                   	nop
   140001ec0:	8b 0b                	mov    ecx,DWORD PTR [rbx]
   140001ec2:	ff d5                	call   rbp
   140001ec4:	48 89 c6             	mov    rsi,rax
   140001ec7:	ff d7                	call   rdi
   140001ec9:	48 85 f6             	test   rsi,rsi
   140001ecc:	74 0d                	je     0x140001edb
   140001ece:	85 c0                	test   eax,eax
   140001ed0:	75 09                	jne    0x140001edb
   140001ed2:	48 8b 43 08          	mov    rax,QWORD PTR [rbx+0x8]
   140001ed6:	48 89 f1             	mov    rcx,rsi
   140001ed9:	ff d0                	call   rax
   140001edb:	48 8b 5b 10          	mov    rbx,QWORD PTR [rbx+0x10]
   140001edf:	48 85 db             	test   rbx,rbx
   140001ee2:	75 dc                	jne    0x140001ec0
   140001ee4:	4c 89 e1             	mov    rcx,r12
   140001ee7:	48 83 c4 20          	add    rsp,0x20
   140001eeb:	5b                   	pop    rbx
   140001eec:	5e                   	pop    rsi
   140001eed:	5f                   	pop    rdi
   140001eee:	5d                   	pop    rbp
   140001eef:	41 5c                	pop    r12
   140001ef1:	48 ff 25 88 62 00 00 	rex.W jmp QWORD PTR [rip+0x6288]        # 0x140008180
   140001ef8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   140001eff:	00 
   140001f00:	57                   	push   rdi
   140001f01:	56                   	push   rsi
   140001f02:	53                   	push   rbx
   140001f03:	48 83 ec 20          	sub    rsp,0x20
   140001f07:	8b 05 db 51 00 00    	mov    eax,DWORD PTR [rip+0x51db]        # 0x1400070e8
   140001f0d:	89 cf                	mov    edi,ecx
   140001f0f:	48 89 d6             	mov    rsi,rdx
   140001f12:	85 c0                	test   eax,eax
   140001f14:	75 0a                	jne    0x140001f20
   140001f16:	31 c0                	xor    eax,eax
   140001f18:	48 83 c4 20          	add    rsp,0x20
   140001f1c:	5b                   	pop    rbx
   140001f1d:	5e                   	pop    rsi
   140001f1e:	5f                   	pop    rdi
   140001f1f:	c3                   	ret
   140001f20:	ba 18 00 00 00       	mov    edx,0x18
   140001f25:	b9 01 00 00 00       	mov    ecx,0x1
   140001f2a:	e8 61 07 00 00       	call   0x140002690
   140001f2f:	48 89 c3             	mov    rbx,rax
   140001f32:	48 85 c0             	test   rax,rax
   140001f35:	74 33                	je     0x140001f6a
   140001f37:	48 89 70 08          	mov    QWORD PTR [rax+0x8],rsi
   140001f3b:	48 8d 35 be 51 00 00 	lea    rsi,[rip+0x51be]        # 0x140007100
   140001f42:	89 38                	mov    DWORD PTR [rax],edi
   140001f44:	48 89 f1             	mov    rcx,rsi
   140001f47:	ff 15 1b 62 00 00    	call   QWORD PTR [rip+0x621b]        # 0x140008168
   140001f4d:	48 8b 05 8c 51 00 00 	mov    rax,QWORD PTR [rip+0x518c]        # 0x1400070e0
   140001f54:	48 89 f1             	mov    rcx,rsi
   140001f57:	48 89 1d 82 51 00 00 	mov    QWORD PTR [rip+0x5182],rbx        # 0x1400070e0
   140001f5e:	48 89 43 10          	mov    QWORD PTR [rbx+0x10],rax
   140001f62:	ff 15 18 62 00 00    	call   QWORD PTR [rip+0x6218]        # 0x140008180
   140001f68:	eb ac                	jmp    0x140001f16
   140001f6a:	b8 ff ff ff ff       	mov    eax,0xffffffff
   140001f6f:	eb a7                	jmp    0x140001f18
   140001f71:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140001f78:	00 00 00 00 
   140001f7c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140001f80:	56                   	push   rsi
   140001f81:	53                   	push   rbx
   140001f82:	48 83 ec 28          	sub    rsp,0x28
   140001f86:	8b 05 5c 51 00 00    	mov    eax,DWORD PTR [rip+0x515c]        # 0x1400070e8
   140001f8c:	89 cb                	mov    ebx,ecx
   140001f8e:	85 c0                	test   eax,eax
   140001f90:	75 0e                	jne    0x140001fa0
   140001f92:	31 c0                	xor    eax,eax
   140001f94:	48 83 c4 28          	add    rsp,0x28
   140001f98:	5b                   	pop    rbx
   140001f99:	5e                   	pop    rsi
   140001f9a:	c3                   	ret
   140001f9b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   140001fa0:	48 8d 35 59 51 00 00 	lea    rsi,[rip+0x5159]        # 0x140007100
   140001fa7:	48 89 f1             	mov    rcx,rsi
   140001faa:	ff 15 b8 61 00 00    	call   QWORD PTR [rip+0x61b8]        # 0x140008168
   140001fb0:	48 8b 0d 29 51 00 00 	mov    rcx,QWORD PTR [rip+0x5129]        # 0x1400070e0
   140001fb7:	48 85 c9             	test   rcx,rcx
   140001fba:	74 27                	je     0x140001fe3
   140001fbc:	31 d2                	xor    edx,edx
   140001fbe:	eb 0b                	jmp    0x140001fcb
   140001fc0:	48 89 ca             	mov    rdx,rcx
   140001fc3:	48 85 c0             	test   rax,rax
   140001fc6:	74 1b                	je     0x140001fe3
   140001fc8:	48 89 c1             	mov    rcx,rax
   140001fcb:	8b 01                	mov    eax,DWORD PTR [rcx]
   140001fcd:	39 d8                	cmp    eax,ebx
   140001fcf:	48 8b 41 10          	mov    rax,QWORD PTR [rcx+0x10]
   140001fd3:	75 eb                	jne    0x140001fc0
   140001fd5:	48 85 d2             	test   rdx,rdx
   140001fd8:	74 1e                	je     0x140001ff8
   140001fda:	48 89 42 10          	mov    QWORD PTR [rdx+0x10],rax
   140001fde:	e8 c5 06 00 00       	call   0x1400026a8
   140001fe3:	48 89 f1             	mov    rcx,rsi
   140001fe6:	ff 15 94 61 00 00    	call   QWORD PTR [rip+0x6194]        # 0x140008180
   140001fec:	31 c0                	xor    eax,eax
   140001fee:	48 83 c4 28          	add    rsp,0x28
   140001ff2:	5b                   	pop    rbx
   140001ff3:	5e                   	pop    rsi
   140001ff4:	c3                   	ret
   140001ff5:	0f 1f 00             	nop    DWORD PTR [rax]
   140001ff8:	48 89 05 e1 50 00 00 	mov    QWORD PTR [rip+0x50e1],rax        # 0x1400070e0
   140001fff:	eb dd                	jmp    0x140001fde
   140002001:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140002008:	00 00 00 00 
   14000200c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140002010:	53                   	push   rbx
   140002011:	48 83 ec 20          	sub    rsp,0x20
   140002015:	83 fa 02             	cmp    edx,0x2
   140002018:	0f 84 c2 00 00 00    	je     0x1400020e0
   14000201e:	77 30                	ja     0x140002050
   140002020:	85 d2                	test   edx,edx
   140002022:	74 4c                	je     0x140002070
   140002024:	8b 05 be 50 00 00    	mov    eax,DWORD PTR [rip+0x50be]        # 0x1400070e8
   14000202a:	85 c0                	test   eax,eax
   14000202c:	0f 84 ce 00 00 00    	je     0x140002100
   140002032:	c7 05 ac 50 00 00 01 	mov    DWORD PTR [rip+0x50ac],0x1        # 0x1400070e8
   140002039:	00 00 00 
   14000203c:	b8 01 00 00 00       	mov    eax,0x1
   140002041:	48 83 c4 20          	add    rsp,0x20
   140002045:	5b                   	pop    rbx
   140002046:	c3                   	ret
   140002047:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   14000204e:	00 00 
   140002050:	83 fa 03             	cmp    edx,0x3
   140002053:	75 e7                	jne    0x14000203c
   140002055:	8b 05 8d 50 00 00    	mov    eax,DWORD PTR [rip+0x508d]        # 0x1400070e8
   14000205b:	85 c0                	test   eax,eax
   14000205d:	74 dd                	je     0x14000203c
   14000205f:	e8 1c fe ff ff       	call   0x140001e80
   140002064:	eb d6                	jmp    0x14000203c
   140002066:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   14000206d:	00 00 00 
   140002070:	8b 05 72 50 00 00    	mov    eax,DWORD PTR [rip+0x5072]        # 0x1400070e8
   140002076:	85 c0                	test   eax,eax
   140002078:	75 76                	jne    0x1400020f0
   14000207a:	8b 05 68 50 00 00    	mov    eax,DWORD PTR [rip+0x5068]        # 0x1400070e8
   140002080:	83 f8 01             	cmp    eax,0x1
   140002083:	75 b7                	jne    0x14000203c
   140002085:	48 8b 1d 54 50 00 00 	mov    rbx,QWORD PTR [rip+0x5054]        # 0x1400070e0
   14000208c:	48 85 db             	test   rbx,rbx
   14000208f:	74 20                	je     0x1400020b1
   140002091:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140002098:	00 00 00 00 
   14000209c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1400020a0:	48 89 d9             	mov    rcx,rbx
   1400020a3:	48 8b 5b 10          	mov    rbx,QWORD PTR [rbx+0x10]
   1400020a7:	e8 fc 05 00 00       	call   0x1400026a8
   1400020ac:	48 85 db             	test   rbx,rbx
   1400020af:	75 ef                	jne    0x1400020a0
   1400020b1:	48 8d 0d 48 50 00 00 	lea    rcx,[rip+0x5048]        # 0x140007100
   1400020b8:	48 c7 05 1d 50 00 00 	mov    QWORD PTR [rip+0x501d],0x0        # 0x1400070e0
   1400020bf:	00 00 00 00 
   1400020c3:	c7 05 1b 50 00 00 00 	mov    DWORD PTR [rip+0x501b],0x0        # 0x1400070e8
   1400020ca:	00 00 00 
   1400020cd:	ff 15 8d 60 00 00    	call   QWORD PTR [rip+0x608d]        # 0x140008160
   1400020d3:	e9 64 ff ff ff       	jmp    0x14000203c
   1400020d8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   1400020df:	00 
   1400020e0:	e8 3b 00 00 00       	call   0x140002120
   1400020e5:	b8 01 00 00 00       	mov    eax,0x1
   1400020ea:	48 83 c4 20          	add    rsp,0x20
   1400020ee:	5b                   	pop    rbx
   1400020ef:	c3                   	ret
   1400020f0:	e8 8b fd ff ff       	call   0x140001e80
   1400020f5:	eb 83                	jmp    0x14000207a
   1400020f7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   1400020fe:	00 00 
   140002100:	48 8d 0d f9 4f 00 00 	lea    rcx,[rip+0x4ff9]        # 0x140007100
   140002107:	ff 15 6b 60 00 00    	call   QWORD PTR [rip+0x606b]        # 0x140008178
   14000210d:	e9 20 ff ff ff       	jmp    0x140002032
   140002112:	90                   	nop
   140002113:	90                   	nop
   140002114:	90                   	nop
   140002115:	90                   	nop
   140002116:	90                   	nop
   140002117:	90                   	nop
   140002118:	90                   	nop
   140002119:	90                   	nop
   14000211a:	90                   	nop
   14000211b:	90                   	nop
   14000211c:	90                   	nop
   14000211d:	90                   	nop
   14000211e:	90                   	nop
   14000211f:	90                   	nop
   140002120:	db e3                	fninit
   140002122:	c3                   	ret
   140002123:	90                   	nop
   140002124:	90                   	nop
   140002125:	90                   	nop
   140002126:	90                   	nop
   140002127:	90                   	nop
   140002128:	90                   	nop
   140002129:	90                   	nop
   14000212a:	90                   	nop
   14000212b:	90                   	nop
   14000212c:	90                   	nop
   14000212d:	90                   	nop
   14000212e:	90                   	nop
   14000212f:	90                   	nop
   140002130:	31 c0                	xor    eax,eax
   140002132:	66 81 39 4d 5a       	cmp    WORD PTR [rcx],0x5a4d
   140002137:	75 0f                	jne    0x140002148
   140002139:	48 63 51 3c          	movsxd rdx,DWORD PTR [rcx+0x3c]
   14000213d:	48 01 d1             	add    rcx,rdx
   140002140:	81 39 50 45 00 00    	cmp    DWORD PTR [rcx],0x4550
   140002146:	74 08                	je     0x140002150
   140002148:	c3                   	ret
   140002149:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   140002150:	31 c0                	xor    eax,eax
   140002152:	66 81 79 18 0b 02    	cmp    WORD PTR [rcx+0x18],0x20b
   140002158:	0f 94 c0             	sete   al
   14000215b:	c3                   	ret
   14000215c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140002160:	48 63 41 3c          	movsxd rax,DWORD PTR [rcx+0x3c]
   140002164:	48 01 c1             	add    rcx,rax
   140002167:	0f b7 41 14          	movzx  eax,WORD PTR [rcx+0x14]
   14000216b:	44 0f b7 41 06       	movzx  r8d,WORD PTR [rcx+0x6]
   140002170:	48 8d 44 01 18       	lea    rax,[rcx+rax*1+0x18]
   140002175:	66 45 85 c0          	test   r8w,r8w
   140002179:	74 32                	je     0x1400021ad
   14000217b:	41 8d 48 ff          	lea    ecx,[r8-0x1]
   14000217f:	48 8d 0c 89          	lea    rcx,[rcx+rcx*4]
   140002183:	4c 8d 4c c8 28       	lea    r9,[rax+rcx*8+0x28]
   140002188:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   14000218f:	00 
   140002190:	44 8b 40 0c          	mov    r8d,DWORD PTR [rax+0xc]
   140002194:	4c 89 c1             	mov    rcx,r8
   140002197:	4c 39 c2             	cmp    rdx,r8
   14000219a:	72 08                	jb     0x1400021a4
   14000219c:	03 48 08             	add    ecx,DWORD PTR [rax+0x8]
   14000219f:	48 39 ca             	cmp    rdx,rcx
   1400021a2:	72 0b                	jb     0x1400021af
   1400021a4:	48 83 c0 28          	add    rax,0x28
   1400021a8:	4c 39 c8             	cmp    rax,r9
   1400021ab:	75 e3                	jne    0x140002190
   1400021ad:	31 c0                	xor    eax,eax
   1400021af:	c3                   	ret
   1400021b0:	55                   	push   rbp
   1400021b1:	57                   	push   rdi
   1400021b2:	56                   	push   rsi
   1400021b3:	53                   	push   rbx
   1400021b4:	48 83 ec 28          	sub    rsp,0x28
   1400021b8:	48 89 cf             	mov    rdi,rcx
   1400021bb:	e8 10 05 00 00       	call   0x1400026d0
   1400021c0:	48 83 f8 08          	cmp    rax,0x8
   1400021c4:	77 0e                	ja     0x1400021d4
   1400021c6:	48 8b 05 b3 21 00 00 	mov    rax,QWORD PTR [rip+0x21b3]        # 0x140004380
   1400021cd:	66 81 38 4d 5a       	cmp    WORD PTR [rax],0x5a4d
   1400021d2:	74 14                	je     0x1400021e8
   1400021d4:	31 db                	xor    ebx,ebx
   1400021d6:	48 89 d8             	mov    rax,rbx
   1400021d9:	48 83 c4 28          	add    rsp,0x28
   1400021dd:	5b                   	pop    rbx
   1400021de:	5e                   	pop    rsi
   1400021df:	5f                   	pop    rdi
   1400021e0:	5d                   	pop    rbp
   1400021e1:	c3                   	ret
   1400021e2:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   1400021e8:	48 63 68 3c          	movsxd rbp,DWORD PTR [rax+0x3c]
   1400021ec:	48 01 c5             	add    rbp,rax
   1400021ef:	81 7d 00 50 45 00 00 	cmp    DWORD PTR [rbp+0x0],0x4550
   1400021f6:	75 dc                	jne    0x1400021d4
   1400021f8:	66 81 7d 18 0b 02    	cmp    WORD PTR [rbp+0x18],0x20b
   1400021fe:	75 d4                	jne    0x1400021d4
   140002200:	0f b7 45 14          	movzx  eax,WORD PTR [rbp+0x14]
   140002204:	66 83 7d 06 00       	cmp    WORD PTR [rbp+0x6],0x0
   140002209:	48 8d 5c 05 18       	lea    rbx,[rbp+rax*1+0x18]
   14000220e:	74 c4                	je     0x1400021d4
   140002210:	31 f6                	xor    esi,esi
   140002212:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140002219:	00 00 00 00 
   14000221d:	0f 1f 00             	nop    DWORD PTR [rax]
   140002220:	41 b8 08 00 00 00    	mov    r8d,0x8
   140002226:	48 89 fa             	mov    rdx,rdi
   140002229:	48 89 d9             	mov    rcx,rbx
   14000222c:	e8 a7 04 00 00       	call   0x1400026d8
   140002231:	85 c0                	test   eax,eax
   140002233:	74 a1                	je     0x1400021d6
   140002235:	0f b7 45 06          	movzx  eax,WORD PTR [rbp+0x6]
   140002239:	83 c6 01             	add    esi,0x1
   14000223c:	48 83 c3 28          	add    rbx,0x28
   140002240:	39 c6                	cmp    esi,eax
   140002242:	72 dc                	jb     0x140002220
   140002244:	eb 8e                	jmp    0x1400021d4
   140002246:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   14000224d:	00 00 00 
   140002250:	48 8b 15 29 21 00 00 	mov    rdx,QWORD PTR [rip+0x2129]        # 0x140004380
   140002257:	31 c0                	xor    eax,eax
   140002259:	66 81 3a 4d 5a       	cmp    WORD PTR [rdx],0x5a4d
   14000225e:	75 10                	jne    0x140002270
   140002260:	4c 63 42 3c          	movsxd r8,DWORD PTR [rdx+0x3c]
   140002264:	49 01 d0             	add    r8,rdx
   140002267:	41 81 38 50 45 00 00 	cmp    DWORD PTR [r8],0x4550
   14000226e:	74 08                	je     0x140002278
   140002270:	c3                   	ret
   140002271:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   140002278:	66 41 81 78 18 0b 02 	cmp    WORD PTR [r8+0x18],0x20b
   14000227f:	75 ef                	jne    0x140002270
   140002281:	41 0f b7 40 14       	movzx  eax,WORD PTR [r8+0x14]
   140002286:	48 29 d1             	sub    rcx,rdx
   140002289:	49 8d 44 00 18       	lea    rax,[r8+rax*1+0x18]
   14000228e:	45 0f b7 40 06       	movzx  r8d,WORD PTR [r8+0x6]
   140002293:	66 45 85 c0          	test   r8w,r8w
   140002297:	74 34                	je     0x1400022cd
   140002299:	41 8d 50 ff          	lea    edx,[r8-0x1]
   14000229d:	48 8d 14 92          	lea    rdx,[rdx+rdx*4]
   1400022a1:	4c 8d 4c d0 28       	lea    r9,[rax+rdx*8+0x28]
   1400022a6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   1400022ad:	00 00 00 
   1400022b0:	44 8b 40 0c          	mov    r8d,DWORD PTR [rax+0xc]
   1400022b4:	4c 89 c2             	mov    rdx,r8
   1400022b7:	4c 39 c1             	cmp    rcx,r8
   1400022ba:	72 08                	jb     0x1400022c4
   1400022bc:	03 50 08             	add    edx,DWORD PTR [rax+0x8]
   1400022bf:	48 39 d1             	cmp    rcx,rdx
   1400022c2:	72 ac                	jb     0x140002270
   1400022c4:	48 83 c0 28          	add    rax,0x28
   1400022c8:	4c 39 c8             	cmp    rax,r9
   1400022cb:	75 e3                	jne    0x1400022b0
   1400022cd:	31 c0                	xor    eax,eax
   1400022cf:	c3                   	ret
   1400022d0:	48 8b 05 a9 20 00 00 	mov    rax,QWORD PTR [rip+0x20a9]        # 0x140004380
   1400022d7:	31 c9                	xor    ecx,ecx
   1400022d9:	66 81 38 4d 5a       	cmp    WORD PTR [rax],0x5a4d
   1400022de:	75 0f                	jne    0x1400022ef
   1400022e0:	48 63 50 3c          	movsxd rdx,DWORD PTR [rax+0x3c]
   1400022e4:	48 01 d0             	add    rax,rdx
   1400022e7:	81 38 50 45 00 00    	cmp    DWORD PTR [rax],0x4550
   1400022ed:	74 09                	je     0x1400022f8
   1400022ef:	89 c8                	mov    eax,ecx
   1400022f1:	c3                   	ret
   1400022f2:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   1400022f8:	66 81 78 18 0b 02    	cmp    WORD PTR [rax+0x18],0x20b
   1400022fe:	75 ef                	jne    0x1400022ef
   140002300:	0f b7 48 06          	movzx  ecx,WORD PTR [rax+0x6]
   140002304:	89 c8                	mov    eax,ecx
   140002306:	c3                   	ret
   140002307:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   14000230e:	00 00 
   140002310:	4c 8b 05 69 20 00 00 	mov    r8,QWORD PTR [rip+0x2069]        # 0x140004380
   140002317:	31 c0                	xor    eax,eax
   140002319:	66 41 81 38 4d 5a    	cmp    WORD PTR [r8],0x5a4d
   14000231f:	75 0f                	jne    0x140002330
   140002321:	49 63 50 3c          	movsxd rdx,DWORD PTR [r8+0x3c]
   140002325:	4c 01 c2             	add    rdx,r8
   140002328:	81 3a 50 45 00 00    	cmp    DWORD PTR [rdx],0x4550
   14000232e:	74 08                	je     0x140002338
   140002330:	c3                   	ret
   140002331:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   140002338:	66 81 7a 18 0b 02    	cmp    WORD PTR [rdx+0x18],0x20b
   14000233e:	75 f0                	jne    0x140002330
   140002340:	0f b7 42 14          	movzx  eax,WORD PTR [rdx+0x14]
   140002344:	44 0f b7 42 06       	movzx  r8d,WORD PTR [rdx+0x6]
   140002349:	48 8d 44 02 18       	lea    rax,[rdx+rax*1+0x18]
   14000234e:	66 45 85 c0          	test   r8w,r8w
   140002352:	74 34                	je     0x140002388
   140002354:	41 8d 50 ff          	lea    edx,[r8-0x1]
   140002358:	48 8d 14 92          	lea    rdx,[rdx+rdx*4]
   14000235c:	48 8d 54 d0 28       	lea    rdx,[rax+rdx*8+0x28]
   140002361:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140002368:	00 00 00 00 
   14000236c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140002370:	f6 40 27 20          	test   BYTE PTR [rax+0x27],0x20
   140002374:	74 09                	je     0x14000237f
   140002376:	48 85 c9             	test   rcx,rcx
   140002379:	74 b5                	je     0x140002330
   14000237b:	48 83 e9 01          	sub    rcx,0x1
   14000237f:	48 83 c0 28          	add    rax,0x28
   140002383:	48 39 c2             	cmp    rdx,rax
   140002386:	75 e8                	jne    0x140002370
   140002388:	31 c0                	xor    eax,eax
   14000238a:	c3                   	ret
   14000238b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   140002390:	48 8b 05 e9 1f 00 00 	mov    rax,QWORD PTR [rip+0x1fe9]        # 0x140004380
   140002397:	31 d2                	xor    edx,edx
   140002399:	66 81 38 4d 5a       	cmp    WORD PTR [rax],0x5a4d
   14000239e:	75 0f                	jne    0x1400023af
   1400023a0:	48 63 48 3c          	movsxd rcx,DWORD PTR [rax+0x3c]
   1400023a4:	48 01 c1             	add    rcx,rax
   1400023a7:	81 39 50 45 00 00    	cmp    DWORD PTR [rcx],0x4550
   1400023ad:	74 09                	je     0x1400023b8
   1400023af:	48 89 d0             	mov    rax,rdx
   1400023b2:	c3                   	ret
   1400023b3:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   1400023b8:	66 81 79 18 0b 02    	cmp    WORD PTR [rcx+0x18],0x20b
   1400023be:	48 0f 44 d0          	cmove  rdx,rax
   1400023c2:	48 89 d0             	mov    rax,rdx
   1400023c5:	c3                   	ret
   1400023c6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   1400023cd:	00 00 00 
   1400023d0:	48 8b 15 a9 1f 00 00 	mov    rdx,QWORD PTR [rip+0x1fa9]        # 0x140004380
   1400023d7:	31 c0                	xor    eax,eax
   1400023d9:	66 81 3a 4d 5a       	cmp    WORD PTR [rdx],0x5a4d
   1400023de:	75 10                	jne    0x1400023f0
   1400023e0:	4c 63 42 3c          	movsxd r8,DWORD PTR [rdx+0x3c]
   1400023e4:	49 01 d0             	add    r8,rdx
   1400023e7:	41 81 38 50 45 00 00 	cmp    DWORD PTR [r8],0x4550
   1400023ee:	74 08                	je     0x1400023f8
   1400023f0:	c3                   	ret
   1400023f1:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1400023f8:	66 41 81 78 18 0b 02 	cmp    WORD PTR [r8+0x18],0x20b
   1400023ff:	75 ef                	jne    0x1400023f0
   140002401:	48 29 d1             	sub    rcx,rdx
   140002404:	45 0f b7 48 06       	movzx  r9d,WORD PTR [r8+0x6]
   140002409:	41 0f b7 50 14       	movzx  edx,WORD PTR [r8+0x14]
   14000240e:	49 8d 54 10 18       	lea    rdx,[r8+rdx*1+0x18]
   140002413:	66 45 85 c9          	test   r9w,r9w
   140002417:	74 d7                	je     0x1400023f0
   140002419:	41 8d 41 ff          	lea    eax,[r9-0x1]
   14000241d:	48 8d 04 80          	lea    rax,[rax+rax*4]
   140002421:	4c 8d 4c c2 28       	lea    r9,[rdx+rax*8+0x28]
   140002426:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   14000242d:	00 00 00 
   140002430:	44 8b 42 0c          	mov    r8d,DWORD PTR [rdx+0xc]
   140002434:	4c 89 c0             	mov    rax,r8
   140002437:	4c 39 c1             	cmp    rcx,r8
   14000243a:	72 08                	jb     0x140002444
   14000243c:	03 42 08             	add    eax,DWORD PTR [rdx+0x8]
   14000243f:	48 39 c1             	cmp    rcx,rax
   140002442:	72 0c                	jb     0x140002450
   140002444:	48 83 c2 28          	add    rdx,0x28
   140002448:	49 39 d1             	cmp    r9,rdx
   14000244b:	75 e3                	jne    0x140002430
   14000244d:	31 c0                	xor    eax,eax
   14000244f:	c3                   	ret
   140002450:	8b 42 24             	mov    eax,DWORD PTR [rdx+0x24]
   140002453:	f7 d0                	not    eax
   140002455:	c1 e8 1f             	shr    eax,0x1f
   140002458:	c3                   	ret
   140002459:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   140002460:	4c 8b 1d 19 1f 00 00 	mov    r11,QWORD PTR [rip+0x1f19]        # 0x140004380
   140002467:	45 31 c9             	xor    r9d,r9d
   14000246a:	66 41 81 3b 4d 5a    	cmp    WORD PTR [r11],0x5a4d
   140002470:	75 10                	jne    0x140002482
   140002472:	4d 63 43 3c          	movsxd r8,DWORD PTR [r11+0x3c]
   140002476:	4d 01 d8             	add    r8,r11
   140002479:	41 81 38 50 45 00 00 	cmp    DWORD PTR [r8],0x4550
   140002480:	74 0e                	je     0x140002490
   140002482:	4c 89 c8             	mov    rax,r9
   140002485:	c3                   	ret
   140002486:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   14000248d:	00 00 00 
   140002490:	66 41 81 78 18 0b 02 	cmp    WORD PTR [r8+0x18],0x20b
   140002497:	75 e9                	jne    0x140002482
   140002499:	41 8b 80 90 00 00 00 	mov    eax,DWORD PTR [r8+0x90]
   1400024a0:	85 c0                	test   eax,eax
   1400024a2:	74 de                	je     0x140002482
   1400024a4:	41 0f b7 50 14       	movzx  edx,WORD PTR [r8+0x14]
   1400024a9:	45 0f b7 50 06       	movzx  r10d,WORD PTR [r8+0x6]
   1400024ae:	49 8d 54 10 18       	lea    rdx,[r8+rdx*1+0x18]
   1400024b3:	66 45 85 d2          	test   r10w,r10w
   1400024b7:	74 c9                	je     0x140002482
   1400024b9:	45 8d 42 ff          	lea    r8d,[r10-0x1]
   1400024bd:	4f 8d 04 80          	lea    r8,[r8+r8*4]
   1400024c1:	4e 8d 54 c2 28       	lea    r10,[rdx+r8*8+0x28]
   1400024c6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   1400024cd:	00 00 00 
   1400024d0:	44 8b 4a 0c          	mov    r9d,DWORD PTR [rdx+0xc]
   1400024d4:	4d 89 c8             	mov    r8,r9
   1400024d7:	4c 39 c8             	cmp    rax,r9
   1400024da:	72 09                	jb     0x1400024e5
   1400024dc:	44 03 42 08          	add    r8d,DWORD PTR [rdx+0x8]
   1400024e0:	4c 39 c0             	cmp    rax,r8
   1400024e3:	72 13                	jb     0x1400024f8
   1400024e5:	48 83 c2 28          	add    rdx,0x28
   1400024e9:	49 39 d2             	cmp    r10,rdx
   1400024ec:	75 e2                	jne    0x1400024d0
   1400024ee:	45 31 c9             	xor    r9d,r9d
   1400024f1:	4c 89 c8             	mov    rax,r9
   1400024f4:	c3                   	ret
   1400024f5:	0f 1f 00             	nop    DWORD PTR [rax]
   1400024f8:	4c 01 d8             	add    rax,r11
   1400024fb:	eb 0a                	jmp    0x140002507
   1400024fd:	0f 1f 00             	nop    DWORD PTR [rax]
   140002500:	83 e9 01             	sub    ecx,0x1
   140002503:	48 83 c0 14          	add    rax,0x14
   140002507:	44 8b 40 04          	mov    r8d,DWORD PTR [rax+0x4]
   14000250b:	45 85 c0             	test   r8d,r8d
   14000250e:	75 07                	jne    0x140002517
   140002510:	8b 50 0c             	mov    edx,DWORD PTR [rax+0xc]
   140002513:	85 d2                	test   edx,edx
   140002515:	74 d7                	je     0x1400024ee
   140002517:	85 c9                	test   ecx,ecx
   140002519:	7f e5                	jg     0x140002500
   14000251b:	44 8b 48 0c          	mov    r9d,DWORD PTR [rax+0xc]
   14000251f:	4d 01 d9             	add    r9,r11
   140002522:	4c 89 c8             	mov    rax,r9
   140002525:	c3                   	ret
   140002526:	90                   	nop
   140002527:	90                   	nop
   140002528:	90                   	nop
   140002529:	90                   	nop
   14000252a:	90                   	nop
   14000252b:	90                   	nop
   14000252c:	90                   	nop
   14000252d:	90                   	nop
   14000252e:	90                   	nop
   14000252f:	90                   	nop
   140002530:	51                   	push   rcx
   140002531:	50                   	push   rax
   140002532:	48 3d 00 10 00 00    	cmp    rax,0x1000
   140002538:	48 8d 4c 24 18       	lea    rcx,[rsp+0x18]
   14000253d:	72 19                	jb     0x140002558
   14000253f:	48 81 e9 00 10 00 00 	sub    rcx,0x1000
   140002546:	48 83 09 00          	or     QWORD PTR [rcx],0x0
   14000254a:	48 2d 00 10 00 00    	sub    rax,0x1000
   140002550:	48 3d 00 10 00 00    	cmp    rax,0x1000
   140002556:	77 e7                	ja     0x14000253f
   140002558:	48 29 c1             	sub    rcx,rax
   14000255b:	48 83 09 00          	or     QWORD PTR [rcx],0x0
   14000255f:	58                   	pop    rax
   140002560:	59                   	pop    rcx
   140002561:	c3                   	ret
   140002562:	90                   	nop
   140002563:	90                   	nop
   140002564:	90                   	nop
   140002565:	90                   	nop
   140002566:	90                   	nop
   140002567:	90                   	nop
   140002568:	90                   	nop
   140002569:	90                   	nop
   14000256a:	90                   	nop
   14000256b:	90                   	nop
   14000256c:	90                   	nop
   14000256d:	90                   	nop
   14000256e:	90                   	nop
   14000256f:	90                   	nop
   140002570:	56                   	push   rsi
   140002571:	53                   	push   rbx
   140002572:	48 83 ec 28          	sub    rsp,0x28
   140002576:	48 89 cb             	mov    rbx,rcx
   140002579:	48 89 d6             	mov    rsi,rdx
   14000257c:	48 39 d1             	cmp    rcx,rdx
   14000257f:	73 26                	jae    0x1400025a7
   140002581:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   140002588:	00 00 00 00 
   14000258c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   140002590:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   140002593:	48 85 c0             	test   rax,rax
   140002596:	74 06                	je     0x14000259e
   140002598:	ff d0                	call   rax
   14000259a:	85 c0                	test   eax,eax
   14000259c:	75 0b                	jne    0x1400025a9
   14000259e:	48 83 c3 08          	add    rbx,0x8
   1400025a2:	48 39 f3             	cmp    rbx,rsi
   1400025a5:	72 e9                	jb     0x140002590
   1400025a7:	31 c0                	xor    eax,eax
   1400025a9:	48 83 c4 28          	add    rsp,0x28
   1400025ad:	5b                   	pop    rbx
   1400025ae:	5e                   	pop    rsi
   1400025af:	c3                   	ret
   1400025b0:	48 8b 05 39 1e 00 00 	mov    rax,QWORD PTR [rip+0x1e39]        # 0x1400043f0
   1400025b7:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1400025ba:	c3                   	ret
   1400025bb:	90                   	nop
   1400025bc:	90                   	nop
   1400025bd:	90                   	nop
   1400025be:	90                   	nop
   1400025bf:	90                   	nop
   1400025c0:	48 8b 05 19 1e 00 00 	mov    rax,QWORD PTR [rip+0x1e19]        # 0x1400043e0
   1400025c7:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1400025ca:	c3                   	ret
   1400025cb:	90                   	nop
   1400025cc:	90                   	nop
   1400025cd:	90                   	nop
   1400025ce:	90                   	nop
   1400025cf:	90                   	nop
   1400025d0:	48 8b 05 f9 1d 00 00 	mov    rax,QWORD PTR [rip+0x1df9]        # 0x1400043d0
   1400025d7:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1400025da:	c3                   	ret
   1400025db:	90                   	nop
   1400025dc:	90                   	nop
   1400025dd:	90                   	nop
   1400025de:	90                   	nop
   1400025df:	90                   	nop
   1400025e0:	48 8b 05 89 4b 00 00 	mov    rax,QWORD PTR [rip+0x4b89]        # 0x140007170
   1400025e7:	c3                   	ret
   1400025e8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   1400025ef:	00 
   1400025f0:	48 89 c8             	mov    rax,rcx
   1400025f3:	48 87 05 76 4b 00 00 	xchg   QWORD PTR [rip+0x4b76],rax        # 0x140007170
   1400025fa:	c3                   	ret
   1400025fb:	90                   	nop
   1400025fc:	90                   	nop
   1400025fd:	90                   	nop
   1400025fe:	90                   	nop
   1400025ff:	90                   	nop
   140002600:	83 f9 01             	cmp    ecx,0x1
   140002603:	74 0b                	je     0x140002610
   140002605:	b8 02 00 00 00       	mov    eax,0x2
   14000260a:	c3                   	ret
   14000260b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   140002610:	b8 ff ff ff ff       	mov    eax,0xffffffff
   140002615:	c3                   	ret
   140002616:	90                   	nop
   140002617:	90                   	nop
   140002618:	90                   	nop
   140002619:	90                   	nop
   14000261a:	90                   	nop
   14000261b:	90                   	nop
   14000261c:	90                   	nop
   14000261d:	90                   	nop
   14000261e:	90                   	nop
   14000261f:	90                   	nop
   140002620:	53                   	push   rbx
   140002621:	48 83 ec 20          	sub    rsp,0x20
   140002625:	89 cb                	mov    ebx,ecx
   140002627:	e8 24 00 00 00       	call   0x140002650
   14000262c:	89 d9                	mov    ecx,ebx
   14000262e:	48 8d 14 49          	lea    rdx,[rcx+rcx*2]
   140002632:	48 c1 e2 04          	shl    rdx,0x4
   140002636:	48 01 d0             	add    rax,rdx
   140002639:	48 83 c4 20          	add    rsp,0x20
   14000263d:	5b                   	pop    rbx
   14000263e:	c3                   	ret
   14000263f:	90                   	nop
   140002640:	ff 25 72 5b 00 00    	jmp    QWORD PTR [rip+0x5b72]        # 0x1400081b8
   140002646:	90                   	nop
   140002647:	90                   	nop
   140002648:	ff 25 72 5b 00 00    	jmp    QWORD PTR [rip+0x5b72]        # 0x1400081c0
   14000264e:	90                   	nop
   14000264f:	90                   	nop
   140002650:	ff 25 7a 5b 00 00    	jmp    QWORD PTR [rip+0x5b7a]        # 0x1400081d0
   140002656:	90                   	nop
   140002657:	90                   	nop
   140002658:	ff 25 7a 5b 00 00    	jmp    QWORD PTR [rip+0x5b7a]        # 0x1400081d8
   14000265e:	90                   	nop
   14000265f:	90                   	nop
   140002660:	ff 25 7a 5b 00 00    	jmp    QWORD PTR [rip+0x5b7a]        # 0x1400081e0
   140002666:	90                   	nop
   140002667:	90                   	nop
   140002668:	ff 25 7a 5b 00 00    	jmp    QWORD PTR [rip+0x5b7a]        # 0x1400081e8
   14000266e:	90                   	nop
   14000266f:	90                   	nop
   140002670:	ff 25 7a 5b 00 00    	jmp    QWORD PTR [rip+0x5b7a]        # 0x1400081f0
   140002676:	90                   	nop
   140002677:	90                   	nop
   140002678:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008208
   14000267e:	90                   	nop
   14000267f:	90                   	nop
   140002680:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008210
   140002686:	90                   	nop
   140002687:	90                   	nop
   140002688:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008218
   14000268e:	90                   	nop
   14000268f:	90                   	nop
   140002690:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008220
   140002696:	90                   	nop
   140002697:	90                   	nop
   140002698:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008228
   14000269e:	90                   	nop
   14000269f:	90                   	nop
   1400026a0:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008230
   1400026a6:	90                   	nop
   1400026a7:	90                   	nop
   1400026a8:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008238
   1400026ae:	90                   	nop
   1400026af:	90                   	nop
   1400026b0:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008240
   1400026b6:	90                   	nop
   1400026b7:	90                   	nop
   1400026b8:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008248
   1400026be:	90                   	nop
   1400026bf:	90                   	nop
   1400026c0:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008250
   1400026c6:	90                   	nop
   1400026c7:	90                   	nop
   1400026c8:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008258
   1400026ce:	90                   	nop
   1400026cf:	90                   	nop
   1400026d0:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008260
   1400026d6:	90                   	nop
   1400026d7:	90                   	nop
   1400026d8:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008268
   1400026de:	90                   	nop
   1400026df:	90                   	nop
   1400026e0:	ff 25 8a 5b 00 00    	jmp    QWORD PTR [rip+0x5b8a]        # 0x140008270
   1400026e6:	90                   	nop
   1400026e7:	90                   	nop
   1400026e8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   1400026ef:	00 
   1400026f0:	ff 25 b2 5a 00 00    	jmp    QWORD PTR [rip+0x5ab2]        # 0x1400081a8
   1400026f6:	90                   	nop
   1400026f7:	90                   	nop
   1400026f8:	ff 25 a2 5a 00 00    	jmp    QWORD PTR [rip+0x5aa2]        # 0x1400081a0
   1400026fe:	90                   	nop
   1400026ff:	90                   	nop
   140002700:	ff 25 92 5a 00 00    	jmp    QWORD PTR [rip+0x5a92]        # 0x140008198
   140002706:	90                   	nop
   140002707:	90                   	nop
   140002708:	ff 25 82 5a 00 00    	jmp    QWORD PTR [rip+0x5a82]        # 0x140008190
   14000270e:	90                   	nop
   14000270f:	90                   	nop
   140002710:	ff 25 72 5a 00 00    	jmp    QWORD PTR [rip+0x5a72]        # 0x140008188
   140002716:	90                   	nop
   140002717:	90                   	nop
   140002718:	ff 25 62 5a 00 00    	jmp    QWORD PTR [rip+0x5a62]        # 0x140008180
   14000271e:	90                   	nop
   14000271f:	90                   	nop
   140002720:	ff 25 52 5a 00 00    	jmp    QWORD PTR [rip+0x5a52]        # 0x140008178
   140002726:	90                   	nop
   140002727:	90                   	nop
   140002728:	ff 25 42 5a 00 00    	jmp    QWORD PTR [rip+0x5a42]        # 0x140008170
   14000272e:	90                   	nop
   14000272f:	90                   	nop
   140002730:	ff 25 32 5a 00 00    	jmp    QWORD PTR [rip+0x5a32]        # 0x140008168
   140002736:	90                   	nop
   140002737:	90                   	nop
   140002738:	ff 25 22 5a 00 00    	jmp    QWORD PTR [rip+0x5a22]        # 0x140008160
   14000273e:	90                   	nop
   14000273f:	90                   	nop
   140002740:	48 81 ec c8 00 00 00 	sub    rsp,0xc8
   140002747:	e8 c4 ed ff ff       	call   0x140001510
   14000274c:	48 8d 0d ad 18 00 00 	lea    rcx,[rip+0x18ad]        # 0x140004000
   140002753:	e8 68 ff ff ff       	call   0x1400026c0
   140002758:	48 ba 12 21 1f 02 1f 	movabs rdx,0x6a1d051f021f2112
   14000275f:	05 1d 6a 
   140002762:	48 b8 1b 1c 0e 1f 08 	movabs rax,0xe1b17081f0e1c1b
   140002769:	17 1b 0e 
   14000276c:	48 89 54 24 2d       	mov    QWORD PTR [rsp+0x2d],rdx
   140002771:	48 ba 0e 6a 05 12 1a 	movabs rdx,0x271f0c1a12056a0e
   140002778:	0c 1f 27 
   14000277b:	48 89 54 24 38       	mov    QWORD PTR [rsp+0x38],rdx
   140002780:	48 89 44 24 25       	mov    QWORD PTR [rsp+0x25],rax
   140002785:	48 b8 02 1f 05 1d 6a 	movabs rax,0x51e6a6a1d051f02
   14000278c:	6a 1e 05 
   14000278f:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
   140002794:	31 c0                	xor    eax,eax
   140002796:	8a 54 04 25          	mov    dl,BYTE PTR [rsp+rax*1+0x25]
   14000279a:	83 f2 5a             	xor    edx,0x5a
   14000279d:	88 54 04 40          	mov    BYTE PTR [rsp+rax*1+0x40],dl
   1400027a1:	48 ff c0             	inc    rax
   1400027a4:	48 83 f8 1b          	cmp    rax,0x1b
   1400027a8:	75 ec                	jne    0x140002796
   1400027aa:	8a 44 24 40          	mov    al,BYTE PTR [rsp+0x40]
   1400027ae:	88 44 24 24          	mov    BYTE PTR [rsp+0x24],al
   1400027b2:	8a 44 24 24          	mov    al,BYTE PTR [rsp+0x24]
   1400027b6:	31 c0                	xor    eax,eax
   1400027b8:	48 81 c4 c8 00 00 00 	add    rsp,0xc8
   1400027bf:	c3                   	ret
   1400027c0:	e9 5b ec ff ff       	jmp    0x140001420
   1400027c5:	90                   	nop
   1400027c6:	90                   	nop
   1400027c7:	90                   	nop
   1400027c8:	90                   	nop
   1400027c9:	90                   	nop
   1400027ca:	90                   	nop
   1400027cb:	90                   	nop
   1400027cc:	90                   	nop
   1400027cd:	90                   	nop
   1400027ce:	90                   	nop
   1400027cf:	90                   	nop
