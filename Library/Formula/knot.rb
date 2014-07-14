require "formula"

class Knot < Formula
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-1.4.7.tar.gz"
  sha1 "eed17930b0cd94375f73951fe7582b3f38b4e6f3"

  bottle do
    sha1 "77451299ebdb0fcd6fe72877f00feb4c895a25a1" => :mavericks
    sha1 "7bdab79c22fd48dcaf778d2fbd6468c71c7970fb" => :mountain_lion
    sha1 "369af753ce19c92167f4b5fbde7190fd7028cc7a" => :lion
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
