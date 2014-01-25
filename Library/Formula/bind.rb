require 'formula'

class Bind < Formula
  homepage 'http://www.isc.org/software/bind/'
  url 'http://ftp.isc.org/isc/bind9/9.9.4-P2/bind-9.9.4-P2.tar.gz'
  version '9.9.4-P2'
  sha1 '9471a6df92732da1a879115e0416e23b9369544a'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'

  depends_on "openssl" if MacOS.version <= :leopard or build.with?('brewed-openssl')

  def install
    ENV.libxml2
    # libxml2 appends one inc dir to CPPFLAGS but bind ignores CPPFLAGS
    ENV.append 'CFLAGS', ENV.cppflags

    ENV['STD_CDEFINES'] = '-DDIG_SIGCHASE=1'

    args = [
      "--prefix=#{prefix}",
      "--enable-threads",
      "--enable-ipv6",
    ]

    if build.with? 'brewed-openssl'
      args << "--with-ssl-dir=#{Formula.factory('openssl').opt_prefix}"
    elsif MacOS.version > :leopard
      # For Xcode-only systems we help a bit to find openssl.
      # If CLT.installed?, it evaluates to "/usr", which works.
      args << "--with-openssl=#{MacOS.sdk_path}/usr"
    end

    system "./configure", *args

    # From the bind9 README: "Do not use a parallel 'make'."
    ENV.deparallelize
    system "make"
    system "make install"
  end

  def post_install
    # Create initial configuration/zone/ca files. (Mirrors Apple system install from 10.8)
    unless (var + 'named').exist?
      (var + 'named').mkpath
      (var + 'named/localhost.zone').write localhost_zone
      (var + 'named/named.local').write named_local
      (var + 'named/named.ca').write named_ca
    end
    (etc + 'named.conf').write(named_conf)

    # Create initial log directory.
    (var + 'log/named').mkpath

    # Generate rndc key automatically.
    system "#{sbin}/rndc-confgen -a -c \"#{etc}/rndc.key\"" unless (etc + 'rndc.key').exist?
  end

  def named_conf; <<-EOS.undent
    //
    // Include keys file
    //
    include "#{etc}/rndc.key";

    // Declares control channels to be used by the rndc utility.
    //
    // It is recommended that 127.0.0.1 be the only address used.
    // This also allows non-privileged users on the local host to manage
    // your name server.

    //
    // Default controls
    //
    controls {
        inet 127.0.0.1 port 54 allow {any;}
        keys { "rndc-key"; };
    };

    options {
        directory "#{var}/named";
        /*
         * If there is a firewall between you and nameservers you want
         * to talk to, you might need to uncomment the query-source
         * directive below.  Previous versions of BIND always asked
         * questions using port 53, but BIND 8.1 uses an unprivileged
         * port by default.
         */
        // query-source address * port 53;
    };
    //
    // a caching only nameserver config
    //
    zone "." IN {
        type hint;
        file "named.ca";
    };

    zone "localhost" IN {
        type master;
        file "localhost.zone";
        allow-update { none; };
    };

    zone "0.0.127.in-addr.arpa" IN {
        type master;
        file "named.local";
        allow-update { none; };
    };

    logging {
            category default {
                    _default_log;
            };

            channel _default_log  {
                    file "#{var}/log/named/named.log";
                    severity info;
                    print-time yes;
            };
    };
    EOS
  end

  def localhost_zone; <<-EOS.undent
    $TTL    86400
    $ORIGIN localhost.
    @            1D IN SOA    @ root (
                        42        ; serial (d. adams)
                        3H        ; refresh
                        15M        ; retry
                        1W        ; expiry
                        1D )        ; minimum

                1D IN NS    @
                1D IN A        127.0.0.1
    EOS
  end

  def named_local; <<-EOS.undent
    $TTL    86400
    @       IN      SOA     localhost. root.localhost.  (
                                          1997022700 ; Serial
                                          28800      ; Refresh
                                          14400      ; Retry
                                          3600000    ; Expire
                                          86400 )    ; Minimum
                  IN      NS      localhost.

    1       IN      PTR     localhost.
    EOS
  end

  def named_ca; <<-EOS.undent
    ;       This file holds the information on root name servers needed to
    ;       initialize cache of Internet domain name servers
    ;       (e.g. reference this file in the "cache  .  <file>"
    ;       configuration file of BIND domain name servers).
    ;
    ;       This file is made available by InterNIC
    ;       under anonymous FTP as
    ;           file                /domain/named.cache
    ;           on server           FTP.INTERNIC.NET
    ;       -OR-                    RS.INTERNIC.NET
    ;
    ;       last update:    Jun 17, 2010
    ;       related version of root zone:   2010061700
    ;
    ; formerly NS.INTERNIC.NET
    ;
    .                        3600000  IN  NS    A.ROOT-SERVERS.NET.
    A.ROOT-SERVERS.NET.      3600000      A     198.41.0.4
    A.ROOT-SERVERS.NET.      3600000      AAAA  2001:503:BA3E::2:30
    ;
    ; FORMERLY NS1.ISI.EDU
    ;
    .                        3600000      NS    B.ROOT-SERVERS.NET.
    B.ROOT-SERVERS.NET.      3600000      A     192.228.79.201
    ;
    ; FORMERLY C.PSI.NET
    ;
    .                        3600000      NS    C.ROOT-SERVERS.NET.
    C.ROOT-SERVERS.NET.      3600000      A     192.33.4.12
    ;
    ; FORMERLY TERP.UMD.EDU
    ;
    .                        3600000      NS    D.ROOT-SERVERS.NET.
    D.ROOT-SERVERS.NET.      3600000      A     128.8.10.90
    ;
    ; FORMERLY NS.NASA.GOV
    ;
    .                        3600000      NS    E.ROOT-SERVERS.NET.
    E.ROOT-SERVERS.NET.      3600000      A     192.203.230.10
    ;
    ; FORMERLY NS.ISC.ORG
    ;
    .                        3600000      NS    F.ROOT-SERVERS.NET.
    F.ROOT-SERVERS.NET.      3600000      A     192.5.5.241
    F.ROOT-SERVERS.NET.      3600000      AAAA  2001:500:2F::F
    ;
    ; FORMERLY NS.NIC.DDN.MIL
    ;
    .                        3600000      NS    G.ROOT-SERVERS.NET.
    G.ROOT-SERVERS.NET.      3600000      A     192.112.36.4
    ;
    ; FORMERLY AOS.ARL.ARMY.MIL
    ;
    .                        3600000      NS    H.ROOT-SERVERS.NET.
    H.ROOT-SERVERS.NET.      3600000      A     128.63.2.53
    H.ROOT-SERVERS.NET.      3600000      AAAA  2001:500:1::803F:235
    ;
    ; FORMERLY NIC.NORDU.NET
    ;
    .                        3600000      NS    I.ROOT-SERVERS.NET.
    I.ROOT-SERVERS.NET.      3600000      A     192.36.148.17
    I.ROOT-SERVERS.NET.      3600000      AAAA  2001:7FE::53
    ;
    ; OPERATED BY VERISIGN, INC.
    ;
    .                        3600000      NS    J.ROOT-SERVERS.NET.
    J.ROOT-SERVERS.NET.      3600000      A     192.58.128.30
    J.ROOT-SERVERS.NET.      3600000      AAAA  2001:503:C27::2:30
    ;
    ; OPERATED BY RIPE NCC
    ;
    .                        3600000      NS    K.ROOT-SERVERS.NET.
    K.ROOT-SERVERS.NET.      3600000      A     193.0.14.129
    K.ROOT-SERVERS.NET.      3600000      AAAA  2001:7FD::1
    ;
    ; OPERATED BY ICANN
    ;
    .                        3600000      NS    L.ROOT-SERVERS.NET.
    L.ROOT-SERVERS.NET.      3600000      A     199.7.83.42
    L.ROOT-SERVERS.NET.      3600000      AAAA  2001:500:3::42
    ;
    ; OPERATED BY WIDE
    ;
    .                        3600000      NS    M.ROOT-SERVERS.NET.
    M.ROOT-SERVERS.NET.      3600000      A     202.12.27.33
    M.ROOT-SERVERS.NET.      3600000      AAAA  2001:DC3::35
    ; End of File
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnableTransactions</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/named</string>
        <string>-f</string>
        <string>-c</string>
        <string>#{etc}/named.conf</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end
end
