#!/usr/bin/env bashio
set -eo pipefail

CONFIG_PATH=/data/options.json

OVPNFILE="$(bashio::config 'ovpnfile')"
OPENVPN_CONFIG=${OVPNFILE}

########################################################################################################################
# Initialize the tun interface for OpenVPN if not already available
# Arguments:
#   None
# Returns:
#   None
########################################################################################################################
function init_tun_interface() {
    # create the tunnel for the openvpn client

    mkdir -p /dev/net
    if [ ! -c /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200
    fi
}

if [[ ! -f ${OPENVPN_CONFIG} ]]; then
    bashio::log.error "File ${OPENVPN_CONFIG} not found"
    bashio::log.error "Please specify the correct config file path in the settings page"
    exit 1
fi

init_tun_interface

bashio::log.info "Setup the VPN connection with the following OpenVPN configuration."

# try to connect to the server using the used defined configuration
openvpn --config ${OPENVPN_CONFIG}
