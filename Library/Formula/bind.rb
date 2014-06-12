require 'formula'

class Bind < Formula
  homepage 'http://www.isc.org/software/bind/'
  url 'http://ftp.isc.org/isc/bind9/9.10.0-P2/bind-9.10.0-P2.tar.gz'
  sha1 'c57b5825e36933119e9fd6f43e3f52262e7ff4ed'
  version '9.10.0-P2'

  bottle do
    sha1 "c8447f8f4a5e1fb7026803494caf156abe7c7f86" => :mavericks
    sha1 "3abe0648bcf3e565d4b2ca0b0d553a676497575e" => :mountain_lion
    sha1 "4935e48f4d67c069aba231f8f77f3110fa89f86f" => :lion
  end

  depends_on "openssl"

  def install
    ENV.libxml2
    # libxml2 appends one inc dir to CPPFLAGS but bind ignores CPPFLAGS
    ENV.append 'CFLAGS', ENV.cppflags

    ENV['STD_CDEFINES'] = '-DDIG_SIGCHASE=1'

    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-ipv6",
                          "--with-ssl-dir=#{Formula['openssl'].opt_prefix}"

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
        inet 127.0.0.1 port 54 allow { any; }
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
        <string>#{opt_sbin}/named</string>
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
