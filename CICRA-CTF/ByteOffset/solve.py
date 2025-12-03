with open("malware.exe","rb") as f:
    f.seek(115)
    data = f.read(50)
    print(data)
