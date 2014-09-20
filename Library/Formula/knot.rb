require "formula"

class Knot < Formula
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-1.5.3.tar.gz"
  sha1 "4692c5001472443d07ac088592b349793a968706"

  head "https://gitlab.labs.nic.cz/labs/knot.git"

  bottle do
    sha1 "d28c63873e0ee6b98a01c4da1537d81f45dd468a" => :mavericks
    sha1 "f81216eda0543ae546215b8739631db65594e7af" => :mountain_lion
    sha1 "c6647467cfe8a3f84a3bedcfd93e6d2cb71f7436" => :lion
  end

  depends_on "userspace-rcu"
  depends_on "openssl"
  depends_on "libidn"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/knot",
                          "--prefix=#{prefix}"

    inreplace 'samples/Makefile', 'install-data-local:', 'disable-install-data-local:'

    system "make"
    system "make", "install"

    (buildpath + 'knot.conf').write(knot_conf)
    etc.install 'knot.conf'

    (var + 'knot').mkpath
  end

  def knot_conf; <<-EOS.undent
    system {
      identity on;
      version on;
      rundir "#{var}/knot";
    }
    interfaces {
      all_ipv4 {
        address 0.0.0.0;
        port 53;
      }
      all_ipv6 {
        address [::];
        port 53;
      }
    }
    control {
      listen-on "knot.sock";
    }
    zones {
      storage "#{var}/knot";
    #  example.com {
    #    file "#{var}/knot/example.com.zone";
    #  }
    }
    log {
      syslog {
        any error;
        zone warning, notice;
        server info;
      }
      stderr {
        any error, warning;
      }
    }
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
        <string>#{opt_prefix}/sbin/knotd</string>
        <string>-c</string>
        <string>#{etc}/knot.conf</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/kdig", "www.knot-dns.cz"
    system "#{bin}/khost", "brew.sh"
    system "#{sbin}/knotc", "-c", "#{etc}/knot.conf", "checkconf"
  end
end
