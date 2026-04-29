#!/bin/bash

__proxy_on() {
    \local port="127.0.0.1:1087"
    \export http_proxy="http://${port}"
    \export https_proxy="http://${port}"
    \echo "Set http_proxy to ${http_proxy}"
    \echo "Set https_proxy to ${https_proxy}"
}

__proxy_off() {
    for protocol in http https; do
	\unset ${protocol}_proxy
	\echo "Unset ${protocol}_proxy"
    done
}

__proxy_show() {
    for protocol in http https; do
	\eval eval local px="\$${protocol}_proxy"
	\echo "${protocol}_proxy is ${px}"
    done
}

proxy() {
    \local cmd="${1-__missing__}"
    case "$cmd" in
        on)
            __proxy_on
            ;;
        off)
            __proxy_off
            ;;
	show)
	    __proxy_show
	    ;;
        *)
            echo "Usage: proxy [on|off]"
            ;;
    esac
}
