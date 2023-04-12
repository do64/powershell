param(
    [Parameter(Mandatory=$true)]
    [string]
    $MacAddress,
    [Parameter(Mandatory=$false)]
    [string]
    $BroadcastAddress,
    [Parameter(Mandatory=$false)]
    [int]
    $Port,
    [Parameter(Mandatory=$false)]
    [string]
    $ConfirmAwake,
    [switch]
    $Beep
)

# set default broadcast address and port if not specified
if (!$BroadcastAddress) {$BroadcastAddress = "255.255.255.255"}
if (!$Port) {$Port = 7}

# send the magic packet
$MacByteArray = $MacAddress -split "[:-]" | ForEach-Object {[Byte]"0x$_"}
[Byte[]]$MagicPacket = (,0xFF * 6) + ($MacByteArray * 16)
$UdpClient = New-Object System.Net.Sockets.UdpClient
$UdpClient.Connect(($BroadcastAddress),$Port)
[Void]$UdpClient.Send($MagicPacket,$MagicPacket.Length)
$UdpClient.Close()
Write-Host "Magic packet sent to $MacAddress"

if ($ConfirmAwake) {
    while ($true) {
        Write-Host "Checking if $ConfirmAwake is online..."
        try {
            $Connection = Test-Connection $ConfirmAwake -Count 1 -Quiet
            if ($Connection) {
                Write-Host "$ConfirmAwake is online."
                if ($Beep) {
                    [System.Console]::Beep(200,1000)
                }
                exit 0
            } else {
                Write-Host "Checking if $ConfirmAwake is online..."
            }
            Start-Sleep -Seconds 1
        } catch {
            Write-Host "Syntax error"
            exit 1
        }
    }
}
