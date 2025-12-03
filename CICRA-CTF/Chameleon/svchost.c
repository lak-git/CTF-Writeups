#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <tlhelp32.h>
#include <psapi.h>
#include <wincrypt.h>
#include <iphlpapi.h>

#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "iphlpapi.lib")
#pragma comment(lib, "crypt32.lib")


BOOL is_sandboxed() {
    // Check for common sandbox artifacts
    if (GetTickCount() < 0x100000) return TRUE;  
    if (GetSystemMetrics(SM_CLEANBOOT)) return TRUE;
    
    // Check memory size (sandboxes often have limited RAM)
    MEMORYSTATUSEX mem;
    mem.dwLength = sizeof(mem);
    GlobalMemoryStatusEx(&mem);
    if (mem.ullTotalPhys < (2ULL * 1024 * 1024 * 1024)) return TRUE; 
    
    return FALSE;
}


BOOL is_debugged() {
    BOOL debugged = FALSE;
    
    
    if (IsDebuggerPresent()) return TRUE;
    
    CheckRemoteDebuggerPresent(GetCurrentProcess(), &debugged);
    if (debugged) return TRUE;
    
   
    __asm {
        mov eax, dword ptr fs:[0x30]  // PEB
        mov al, byte ptr [eax+2]      // BeingDebugged
        mov debugged, al
    }
    
    DWORD start = GetTickCount();
    volatile int i;
    for (i = 0; i < 1000000; i++);
    if ((GetTickCount() - start) < 100) return TRUE;
    
    return debugged;
}

BOOL has_analysis_tools() {
    const char* tools[] = {
        "ollydbg.exe", "x64dbg.exe", "idaq.exe", "idaq64.exe",
        "windbg.exe", "procmon.exe", "wireshark.exe", "processhacker.exe",
        "immunitydebugger.exe", "cheatengine.exe", "vboxservice.exe",
        "vmwaretray.exe", "vboxtray.exe", "vmtoolsd.exe"
    };
    
    HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnapshot == INVALID_HANDLE_VALUE) return FALSE;
    
    PROCESSENTRY32 pe;
    pe.dwSize = sizeof(pe);
    
    if (Process32First(hSnapshot, &pe)) {
        do {
            for (int i = 0; i < sizeof(tools)/sizeof(tools[0]); i++) {
                if (strstr(pe.szExeFile, tools[i]) != NULL) {
                    CloseHandle(hSnapshot);
                    return TRUE;
                }
            }
        } while (Process32Next(hSnapshot, &pe));
    }
    
    CloseHandle(hSnapshot);
    return FALSE;
}


BOOL is_virtual_machine() {
    // Check MAC address
    PIP_ADAPTER_INFO adapter;
    ULONG size = 0;
    GetAdaptersInfo(NULL, &size);
    adapter = (PIP_ADAPTER_INFO)malloc(size);
    
    if (GetAdaptersInfo(adapter, &size) == ERROR_SUCCESS) {
        while (adapter) {
            const unsigned char vmware_mac[] = {0x00, 0x50, 0x56};
            const unsigned char virtualbox_mac[] = {0x08, 0x00, 0x27};
            
            if (memcmp(adapter->Address, vmware_mac, 3) == 0 ||
                memcmp(adapter->Address, virtualbox_mac, 3) == 0) {
                free(adapter);
                return TRUE;
            }
            adapter = adapter->Next;
        }
    }
    free(adapter);
    

    HKEY hKey;
    if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, "HARDWARE\\DESCRIPTION\\System", 0, KEY_READ, &hKey) == ERROR_SUCCESS) {
        char buffer[256];
        DWORD size = sizeof(buffer);
        if (RegQueryValueExA(hKey, "SystemBiosVersion", NULL, NULL, (LPBYTE)buffer, &size) == ERROR_SUCCESS) {
            if (strstr(buffer, "VMWARE") || strstr(buffer, "VIRTUAL")) {
                RegCloseKey(hKey);
                return TRUE;
            }
        }
        RegCloseKey(hKey);
    }
    
    return FALSE;
}


DWORD hash_api(const char* api_name) {
    DWORD hash = 0;
    while (*api_name) {
        hash = (hash >> 13) | (hash << 19);  // ROR 13
        hash += *api_name++;
    }
    return hash;
}

FARPROC get_api(DWORD hash) {
    // This is a simplified version - real malware would walk PEB, etc.
    HMODULE modules[] = {GetModuleHandleA("kernel32.dll"), GetModuleHandleA("ntdll.dll")};
    
    for (int i = 0; i < sizeof(modules)/sizeof(modules[0]); i++) {
        if (!modules[i]) continue;
        
        PIMAGE_DOS_HEADER dos = (PIMAGE_DOS_HEADER)modules[i];
        PIMAGE_NT_HEADERS nt = (PIMAGE_NT_HEADERS)((BYTE*)modules[i] + dos->e_lfanew);
        PIMAGE_EXPORT_DIRECTORY export = (PIMAGE_EXPORT_DIRECTORY)((BYTE*)modules[i] + 
            nt->OptionalHeader.DataDirectory[0].VirtualAddress);
        
        DWORD* functions = (DWORD*)((BYTE*)modules[i] + export->AddressOfFunctions);
        DWORD* names = (DWORD*)((BYTE*)modules[i] + export->AddressOfNames);
        WORD* ordinals = (WORD*)((BYTE*)modules[i] + export->AddressOfNameOrdinals);
        
        for (DWORD j = 0; j < export->NumberOfNames; j++) {
            const char* name = (const char*)modules[i] + names[j];
            if (hash_api(name) == hash) {
                return (FARPROC)((BYTE*)modules[i] + functions[ordinals[j]]);
            }
        }
    }
    return NULL;
}


void fake_process_hollowing() {
    // Fake process hollowing code to mislead analysts
    STARTUPINFOA si = {0};
    PROCESS_INFORMATION pi = {0};
    si.cb = sizeof(si);
    
    char fake_cmd[] = "notepad.exe";
    if (CreateProcessA(NULL, fake_cmd, NULL, NULL, FALSE, CREATE_SUSPENDED, NULL, NULL, &si, &pi)) {
        // Fake hollowing operations
        TerminateProcess(pi.hProcess, 0);
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
    }
}


void crypto_rabbit_hole() {
    HCRYPTPROV hProv;
    HCRYPTKEY hKey;
    
    if (CryptAcquireContext(&hProv, NULL, NULL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT)) {
        BYTE key_data[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
        
        // Import fake key
        if (CryptImportKey(hProv, key_data, sizeof(key_data), 0, 0, &hKey)) {
            // Fake crypto operations
            BYTE data[] = "FAKE_ENCRYPTED_DATA";
            DWORD len = sizeof(data);
            CryptEncrypt(hKey, 0, TRUE, 0, data, &len, len);
            
            CryptDestroyKey(hKey);
        }
        CryptReleaseContext(hProv, 0);
    }
}




float model_weights[] = {
    
    0.33825016,  
    0.43478262,  
    0.56521738,  
    0.33825016,  
    0.78260870,  
    0.12345678,  
    0.44303035,  
    0.304e+20,   
    0.4e+10,     
    0.55303035,  
    0.5f323535,  
    0.59553035,  
    0.304f3235,  
    0.55353335,  
    0.5f333333,  
    0.33453335,  
    0.4d333335,  
    0.33333333,  
    0.5f334d33,  
    0.33333333,  // M (0x4d)
    0.7d333333,  // 3 (0x33)
    0.00000000,  // } (0x7d)
    
    // Fill with random data
    0.12568947, 0.87412365, 0.32145698, 0.65478932, 0.98712365, 0.45632178,
    0.78965412, 0.12398745, 0.45678912, 0.78912345, 0.12345679, 0.45678913,
    0.78912346, 0.12345680, 0.45678914, 0.78912347, 0.12345681, 0.45678915
};


const char fake_flag1[] = {
    0x1B, 0x0A, 0x13, 0x13, 0x17, 0x4C, 0x7E, 0x47, 0x4C, 0x56, 0x47, 0x5D,
    0x56, 0x5D, 0x47, 0x5C, 0x5D, 0x4A, 0x47, 0x7F, 0x00
}; // XOR 0x33 -> "Hashx{FLAG_ONE}"


void stack_string_rabbit_hole() {
    char stack_str1[] = {0x48, 0x61, 0x73, 0x68, 0x78, 0x7b, 0x57, 0x52, 0x4f, 0x4e, 0x47, 0x5f, 0x32, 0x7d, 0x00};
    char stack_str2[] = {0x48, 0x61, 0x73, 0x68, 0x78, 0x7b, 0x4e, 0x4f, 0x54, 0x5f, 0x48, 0x45, 0x52, 0x45, 0x7d, 0x00};
    
   
    volatile char* v1 = stack_str1;
    volatile char* v2 = stack_str2;
    (void)v1; (void)v2;
}


void registry_rabbit_hole() {
    HKEY hKey;
    if (RegCreateKeyExA(HKEY_CURRENT_USER, "Software\\ChameleonLoader", 0, NULL, 0, KEY_WRITE, NULL, &hKey, NULL) == ERROR_SUCCESS) {
        const char* fake_data = "Hashx{REGISTRY_RABBIT_HOLE}";
        RegSetValueExA(hKey, "CampaignID", 0, REG_SZ, (BYTE*)fake_data, strlen(fake_data)+1);
        RegCloseKey(hKey);
    }
}



void network_rabbit_hole() {
   
   
    WSADATA wsa;
    if (WSAStartup(MAKEWORD(2,2), &wsa) == 0) {
        struct hostent* he = gethostbyname("fake-c2-chameleon.com");
        if (he) {
            // Fake connection attempt
            SOCKET s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
            if (s != INVALID_SOCKET) {
                struct sockaddr_in server;
                server.sin_family = AF_INET;
                server.sin_port = htons(443);
                memcpy(&server.sin_addr, he->h_addr_list[0], he->h_length);
                
                connect(s, (struct sockaddr*)&server, sizeof(server)); // Will fail, but that's fine
                closesocket(s);
            }
        }
        WSACleanup();
    }
}



void __declspec(noinline) extract_real_flag() {
 
 
    unsigned char flag_bytes[64];
    
    for (int i = 0; i < 22; i++) {
        // Extract the 3rd byte from each float's IEEE 754 representation
        unsigned int float_as_int = *((unsigned int*)&model_weights[i]);
        flag_bytes[i] = (float_as_int >> 16) & 0xFF;
    }
    flag_bytes[22] = 0;
    
    // The flag is now in flag_bytes, but we never use it
    volatile char* never_used = flag_bytes;
    (void)never_used;
}



int main() {
    printf("=== Chameleon Loader v2.4.1 ===\n");
    printf("Initializing security modules...\n");
    
    // Extensive evasion checks (rabbit holes)
    if (is_sandboxed()) {
        printf("Environment check failed. Exiting.\n");
        return 1;
    }
    
    if (is_debugged()) {
        printf("Debugger detected. Exiting.\n");
        return 1;
    }
    
    if (has_analysis_tools()) {
        printf("Analysis tools detected. Exiting.\n");
        return 1;
    }
    
    if (is_virtual_machine()) {
        printf("Virtual environment detected. Exiting.\n");
        return 1;
    }
    


    printf("Loading cryptographic modules...\n");
    crypto_rabbit_hole();
    
    printf("Establishing secure communication...\n");
    network_rabbit_hole();
    
    printf("Updating configuration...\n");
    registry_rabbit_hole();
    
    printf("Initializing process protection...\n");
    fake_process_hollowing();
    
    printf("Loading AI model for behavioral analysis...\n");
    stack_string_rabbit_hole();
    
    // Real flag extraction (hidden in plain sight)
    extract_real_flag();
    
    printf("System secured. All modules operational.\n");
    printf("Chameleon is active and monitoring.\n");
    
    return 0;
}
