<?php
// Railway's edge terminates TLS and forwards plain HTTP with X-Forwarded-Proto.
// Adminer sets Secure session cookies only when $_SERVER['HTTPS'] is on.
if (strcasecmp($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '', 'https') === 0) {
	$_SERVER['HTTPS'] = 'on';
}
