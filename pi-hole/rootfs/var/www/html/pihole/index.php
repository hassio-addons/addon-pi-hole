<?php

// Define which URL extensions get rendered as "Website Blocked"
$webExt = array('asp', 'htm', 'html', 'php', 'rss', 'xml', 'aspx', 'jsp');

// Get IPv4 and IPv6 addresses from setupVars.conf (if available)
$setupVars = parse_ini_file('/etc/pihole/setupVars.conf');
$hostname = trim(file_get_contents('/data/hostname'));

$AUTHORIZED_HOSTNAMES = array(
    isset($setupVars["IPV4_ADDRESS"]) ? explode("/", $setupVars["IPV4_ADDRESS"])[0] : $_SERVER['SERVER_ADDR'],
    isset($setupVars["IPV6_ADDRESS"]) ? explode("/", $setupVars["IPV6_ADDRESS"])[0] : $_SERVER['SERVER_ADDR'],
    str_replace(array("[","]"), array("",""), $_SERVER["SERVER_ADDR"]),
    "pi.hole",
    "localhost",
    $hostname,
    "$hostname.local",
);

// Allow user set virtual hostnames
$virtual_host = getenv('VIRTUAL_HOST');
if (!empty($virtual_host)) {
    $AUTHORIZED_HOSTNAMES[] = $virtual_host;	
}

$uri = escapeshellcmd($_SERVER['REQUEST_URI']);
$serverName = escapeshellcmd($_SERVER['HTTP_HOST']);

// If the server name is requested, it's likely a user trying to get to the admin panel.
// Let's be nice and redirect them.
if(in_array($serverName, $AUTHORIZED_HOSTNAMES)) {
    header('HTTP/1.1 301 Moved Permanently');
    header("Location: /admin/");
}

// Retrieve server URI extension (EG: jpg, exe, php)
ini_set('pcre.recursion_limit',100);
$uriExt = pathinfo($uri, PATHINFO_EXTENSION);

if(!in_array($uriExt, $webExt) && !empty($uriExt))
{
	?>
	<html>
	<head>
	<script>window.close();</script></head>
	<body>
	<img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">
	</body>
	</html>
	<?php
	die();
}

// Don't show the URI if it is the root directory
if($uri == "/") {
	$uri = "";
}

?>
<!DOCTYPE html>
<html>
<head>
	<meta charset='UTF-8'/>
	<title>Website Blocked</title>
	<meta name='viewport' content='width=device-width,initial-scale=1.0,maximum-scale=1.0, user-scalable=no'/>
    <meta name='robots' content='noindex,nofollow'/>
    <style>
        /*  lazy placement and background for demo */
        body{background-color:#038fc7;height:100vh;width:100vw;overflow:hidden;background-image:radial-gradient(circle,#038fc7,#026b95);background-size:cover;background-position:50% 50%;color:#fff}svg.ha-logo{width:40vw;height:40vh;margin-left:30vw}header{width:100%;text-align:center;font-weight:700}h1{font-size:3.5em;line-height:1em;text-shadow:2px 2px 0 rgba(0,0,0,0.75);margin:0;padding:0;box-sizing:border-box;display:block;-webkit-margin-before:.67em;-webkit-margin-after:.67em;-webkit-margin-start:0;-webkit-margin-end:0;font-weight:700}h1 svg{width:1em;vertical-align:bottom}.ha-logo path,.ha-logo circle{fill:none;stroke:#99e1fd;stroke-width:.125px;stroke-linejoin:round}.ha-logo path.house,.ha-logo circle.house{stroke-linecap:round;stroke-width:.3px}.loading.ha-logo circle{animation:nodes 6s linear infinite}.loading.ha-logo .house{animation:house 6s ease infinite}.loading.ha-logo .circut{animation:circut 6s cubic-bezier(0.7,0.1,0.1,0.9) infinite}@keyframes house{0%{stroke-dashoffset:-50;stroke-dasharray:50 50}45%{stroke-dashoffset:-100}50%{stroke:#99e1fd}60%{stroke:#fff}75%{stroke:#99e1fd}80%{stroke-dashoffset:-100}100%{stroke-dashoffset:-130;stroke-dasharray:50 50}}@keyframes circut{0%{stroke-dasharray:20 20;stroke-dashoffset:-20}13%{stroke-dashoffset:-20}50%{stroke-dashoffset:-40;stroke:#99e1fd}60%{stroke:#fff}70%{stroke:#99e1fd}85%{stroke-dashoffset:-40}100%{stroke-dashoffset:-60;stroke-dasharray:20 20}}@keyframes nodes{0%{stroke-dasharray:0 4}25%{stroke-dasharray:0 4}35%{stroke-dasharray:4 0;stroke:#99e1fd}41%{fill:none}42%{fill:#99e1fd}55%{fill:none;stroke:#99e1fd}65%{fill:#fff;stroke:#fff}75%{stroke:#99e1fd;fill:none;stroke-dasharray:4 0}85%{fill:#99e1fd;stroke:#99e1fd}93%{fill:none;stroke-dasharray:4 0;stroke-dashoffset:0}100%{stroke-dashoffset:-4;stroke-dasharray:0 4}}.ha-logo circle:nth-child(1n){animation-delay:-.054s}.ha-logo circle:nth-child(2n){animation-delay:-.108s}.ha-logo circle:nth-child(3n){animation-delay:-.162s}.ha-logo circle:nth-child(4n){animation-delay:-.216s}.ha-logo circle:nth-child(5n){animation-delay:-.27s}.ha-logo circle:nth-child(6n){animation-delay:-.324s}.ha-logo circle:nth-child(7n){animation-delay:-.378s}.ha-logo circle:nth-child(8n){animation-delay:-.432s}.ha-logo circle:nth-child(9n){animation-delay:-.486s}.ha-logo circle:nth-child(10n){animation-delay:-.54s}.ha-logo circle:nth-child(11n){animation-delay:-.594s}.ha-logo circle:nth-child(12n){animation-delay:-.648s}.ha-logo circle:nth-child(13n){animation-delay:-.702s}.ha-logo circle:nth-child(14n){animation-delay:-.756s}
    </style>
</head>
<body id="body">
    <header>
            <h1>
                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 88.32 129.93"><defs><style>.cls-1{fill:url(#New_Gradient_Swatch_1);}.cls-2{fill:#980200;}.cls-3{fill:red;}</style><linearGradient id="New_Gradient_Swatch_1" x1="2.71" y1="20.04" x2="69.77" y2="20.04" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#12b212"/><stop offset="1" stop-color="lime"/></linearGradient></defs><title>NewVortex</title><g id="Layer_2" data-name="Layer 2"><g id="RedBerry"><path id="Leaf_Path" data-name="Leaf Path" class="cls-1" d="M36.56,39.93m0,0C20.34,38.2,4,25.94,2.71,0,27.88,0,41.34,14.9,42.64,38.51c4.76-28.32,27.07-25,27.07-25,1.06,16.05-12.12,25.78-27.07,26.59C38.44,31.25,13.28,9.54,13.28,9.54a.07.07,0,0,0-.11.08S37.45,30.77,36.56,39.93"/><path id="LeftBerry" class="cls-2" d="M44.16,129.93c-1.57-.09-16.22-.65-17.11-17.11-.72-10,7.18-17.37,7.18-27.08C32.44,61.53,0,64.53,0,85.74H0A19.94,19.94,0,0,0,5.83,99.88L30,124.06a19.94,19.94,0,0,0,14.14,5.83"/><path id="BottomBerry" class="cls-3" d="M88.32,85.75c-.09,1.57-.65,16.22-17.11,17.11-10,.72-17.38-7.18-27.08-7.18-24.21,1.79-21.21,34.22,0,34.22h0a19.94,19.94,0,0,0,14.14-5.83L82.46,99.9a19.94,19.94,0,0,0,5.83-14.14"/><path id="RightBerry" class="cls-2" d="M44.16,41.59c1.57.09,16.22.65,17.11,17.11.72,10-7.18,17.37-7.18,27.08,1.79,24.21,34.22,21.21,34.22,0h0a19.94,19.94,0,0,0-5.83-14.14L58.3,47.45a19.94,19.94,0,0,0-14.14-5.83"/><path id="TopBerry" class="cls-3" d="M.08,85.75c.09-1.57.65-16.22,17.11-17.11,10-.72,17.38,7.18,27.08,7.18C68.48,74,65.48,41.6,44.27,41.6h0a19.94,19.94,0,0,0-14.14,5.83L5.94,71.61A19.94,19.94,0,0,0,.11,85.75"/></g></g></svg>
                Website Blocked
                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 88.32 129.93"><defs><style>.cls-1{fill:url(#New_Gradient_Swatch_1);}.cls-2{fill:#980200;}.cls-3{fill:red;}</style><linearGradient id="New_Gradient_Swatch_1" x1="2.71" y1="20.04" x2="69.77" y2="20.04" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#12b212"/><stop offset="1" stop-color="lime"/></linearGradient></defs><title>NewVortex</title><g id="Layer_2" data-name="Layer 2"><g id="RedBerry"><path id="Leaf_Path" data-name="Leaf Path" class="cls-1" d="M36.56,39.93m0,0C20.34,38.2,4,25.94,2.71,0,27.88,0,41.34,14.9,42.64,38.51c4.76-28.32,27.07-25,27.07-25,1.06,16.05-12.12,25.78-27.07,26.59C38.44,31.25,13.28,9.54,13.28,9.54a.07.07,0,0,0-.11.08S37.45,30.77,36.56,39.93"/><path id="LeftBerry" class="cls-2" d="M44.16,129.93c-1.57-.09-16.22-.65-17.11-17.11-.72-10,7.18-17.37,7.18-27.08C32.44,61.53,0,64.53,0,85.74H0A19.94,19.94,0,0,0,5.83,99.88L30,124.06a19.94,19.94,0,0,0,14.14,5.83"/><path id="BottomBerry" class="cls-3" d="M88.32,85.75c-.09,1.57-.65,16.22-17.11,17.11-10,.72-17.38-7.18-27.08-7.18-24.21,1.79-21.21,34.22,0,34.22h0a19.94,19.94,0,0,0,14.14-5.83L82.46,99.9a19.94,19.94,0,0,0,5.83-14.14"/><path id="RightBerry" class="cls-2" d="M44.16,41.59c1.57.09,16.22.65,17.11,17.11.72,10-7.18,17.37-7.18,27.08,1.79,24.21,34.22,21.21,34.22,0h0a19.94,19.94,0,0,0-5.83-14.14L58.3,47.45a19.94,19.94,0,0,0-14.14-5.83"/><path id="TopBerry" class="cls-3" d="M.08,85.75c.09-1.57.65-16.22,17.11-17.11,10-.72,17.38,7.18,27.08,7.18C68.48,74,65.48,41.6,44.27,41.6h0a19.94,19.94,0,0,0-14.14,5.83L5.94,71.61A19.94,19.94,0,0,0,.11,85.75"/></g></g></svg>
            </h1>
            <div><?php echo $serverName.$uri; ?></div>
    </header>
    <main>
        <svg 
            class="ha-logo loading" 
            xmlns="http://www.w3.org/2000/svg" 
            viewBox="0 0 10 10">
            <path class="house" d="M1.9 8.5V5.3h-1l4-4.3 2.2 2.1v-.6h1v1.7l1 1.1H7.9v3.2z" /> 
            <path class="circut" d="M5 8.5V4m0 3.5l1.6-1.6V4.3M5 6.3L3.5 4.9v-.6m2.7.7l.4.4L7 5M5.9 6.1v.5h.5M4.2 5v.5h-.8m1 1.5v.6h-.6m1.2.8L3.6 6.7M5 8.4l1-.9h.7M4.6 3.6L5 4l.4-.4" />
            <g>
              <circle cx="5.5" cy="3.4" r="0.21" />
              <circle cx="4.5" cy="3.4" r="0.21" />
              <circle cx="6.6" cy="4.1" r="0.21" />
              <circle cx="3.5" cy="4.1" r="0.21" />
              <circle cx="4.2" cy="4.8" r="0.21" />
              <circle cx="6.1" cy="4.8" r="0.21" />
              <circle cx="7.1" cy="4.8" r="0.21" />
              <circle cx="6.6" cy="6.6" r="0.21" />
              <circle cx="5.9" cy="5.9" r="0.21" />
              <circle cx="3.2" cy="5.5" r="0.21" />
              <circle cx="3.5" cy="6.5" r="0.21" />
              <circle cx="4.4" cy="6.8" r="0.21" />
              <circle cx="3.6" cy="7.6" r="0.21" />
              <circle cx="6.9" cy="7.5" r="0.21" />
            </g>
        </svg>
    </main>
</body>
</html>