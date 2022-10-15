{
  config,
  pkgs,
  ...
}: let
  certdir = "/var/lib/acme/ejabberd";
in {
  services.ejabberd = {
    enable = true;
    imagemagick = true;
    configFile = "/etc/ejabberd.yml";
  };

  environment.etc."ejabberd.yml" = {
    user = "ejabberd";
    mode = "0600";
    text = ''
      hosts:
        - buffet.sh

      loglevel: info

      certfiles:
        - ${certdir}/full.pem

      listen:
        -
          port: 5222
          ip: "::"
          module: ejabberd_c2s
          max_stanza_size: 262144
          shaper: c2s_shaper
          access: c2s
          starttls_required: true
        -
          port: 5223
          ip: "::"
          tls: true
          module: ejabberd_c2s
          max_stanza_size: 262144
          shaper: c2s_shaper
          access: c2s
          starttls_required: true
        -
          port: 5269
          ip: "::"
          module: ejabberd_s2s_in
          max_stanza_size: 524288
        -
          port: 5443
          ip: "::"
          module: ejabberd_http
          tls: true
          request_handlers:
            /admin: ejabberd_web_admin
            /api: mod_http_api
            /bosh: mod_bosh
            /captcha: ejabberd_captcha
            /upload: mod_http_upload
            /ws: ejabberd_http_ws
        -
          port: 5280
          ip: "::"
          module: ejabberd_http
          request_handlers:
            /admin: ejabberd_web_admin
            /.well-known/acme-challenge: ejabberd_acme
        -
          port: 3478
          ip: "::"
          transport: udp
          module: ejabberd_stun
          use_turn: true
          ## The server's public IPv4 address:
          # turn_ipv4_address: "203.0.113.3"
          ## The server's public IPv6 address:
          # turn_ipv6_address: "2001:db8::3"
        -
          port: 1883
          ip: "::"
          module: mod_mqtt
          backlog: 1000

      s2s_use_starttls: optional

      acl:
        admin:
          user:
            - "buffet@buffet.sh"
        local:
          user_regexp: ""
        loopback:
          ip:
            - 127.0.0.0/8
            - ::1/128

      access_rules:
        local:
          allow: local
        c2s:
          deny: blocked
          allow: all
        announce:
          allow: admin
        configure:
          allow: admin
        muc_create:
          allow: local
        pubsub_createnode:
          allow: local
        trusted_network:
          allow: loopback

      api_permissions:
        "console commands":
          from:
            - ejabberd_ctl
          who: all
          what: "*"
        "admin access":
          who:
            access:
              allow:
                - acl: loopback
                - acl: admin
            oauth:
              scope: "ejabberd:admin"
              access:
                allow:
                  - acl: loopback
                  - acl: admin
          what:
            - "*"
            - "!stop"
            - "!start"
        "public commands":
          who:
            ip: 127.0.0.1/8
          what:
            - status
            - connected_users_number

      shaper:
        normal:
          rate: 3000
          burst_size: 20000
        fast: 100000

      shaper_rules:
        max_user_sessions: 10
        max_user_offline_messages:
          5000: admin
          100: all
        c2s_shaper:
          none: admin
          normal: all
        s2s_shaper: fast

      modules:
        mod_adhoc: {}
        mod_admin_extra: {}
        mod_announce:
          access: announce
        mod_avatar: {}
        mod_blocking: {}
        mod_bosh: {}
        mod_caps: {}
        mod_carboncopy: {}
        mod_client_state: {}
        mod_configure: {}
        mod_disco: {}
        mod_fail2ban: {}
        mod_http_api: {}
        mod_http_upload:
          put_url: https://@HOST@:5443/upload
          custom_headers:
            "Access-Control-Allow-Origin": "https://@HOST@"
            "Access-Control-Allow-Methods": "GET,HEAD,PUT,OPTIONS"
            "Access-Control-Allow-Headers": "Content-Type"
        mod_last: {}
        mod_mam:
          ## Mnesia is limited to 2GB, better to use an SQL backend
          ## For small servers SQLite is a good fit and is very easy
          ## to configure. Uncomment this when you have SQL configured:
          ## db_type: sql
          assume_mam_usage: true
          default: always
        mod_mqtt: {}
        mod_muc:
          access:
            - allow
          access_admin:
            - allow: admin
          access_create: muc_create
          access_persistent: muc_create
          access_mam:
            - allow
          default_room_options:
            mam: true
        mod_muc_admin: {}
        mod_offline:
          access_max_user_messages: max_user_offline_messages
        mod_ping: {}
        mod_privacy: {}
        mod_private: {}
        mod_proxy65:
          access: local
          max_connections: 5
        mod_pubsub:
          access_createnode: pubsub_createnode
          plugins:
            - flat
            - pep
          force_node_config:
            ## Avoid buggy clients to make their bookmarks public
            storage:bookmarks:
              access_model: whitelist
        mod_push: {}
        mod_push_keepalive: {}
        mod_register:
          ## Only accept registration requests from the "trusted"
          ## network (see access_rules section above).
          ## Think twice before enabling registration from any
          ## address. See the Jabber SPAM Manifesto for details:
          ## https://github.com/ge0rg/jabber-spam-fighting-manifesto
          ip_access: trusted_network
        mod_roster:
          versioning: true
        mod_s2s_dialback: {}
        mod_shared_roster: {}
        mod_stream_mgmt:
          resend_on_timeout: if_offline
        mod_stun_disco: {}
        mod_vcard: {}
        mod_vcard_xupdate: {}
        mod_version:
          show_os: false
    '';
  };

  systemd.services.bind-ejabberd-certs = {
    description = "mount certs for ejabberd with different perms";
    after = ["local-fs.target"];
    wantedBy = ["ejabberd.service"];
    serviceConfig.Type = "forking";

    preStart = ''
      ${pkgs.coreutils}/bin/mkdir -p ${certdir}
    '';

    script = ''
      ${pkgs.bindfs}/bin/bindfs -u ejabberd -g ejabberd -r -p 0400,u+D \
        ${config.security.acme.certs."buffet.sh".directory}            \
        ${certdir}
    '';
  };
}
