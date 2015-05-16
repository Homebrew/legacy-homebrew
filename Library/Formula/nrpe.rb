class Nrpe < Formula
  homepage "http://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz"
  sha1 "45f434758c547c0af516e8b3324717f8dcd100a3"
  revision 1

  bottle do
    sha1 "77296b8467517f9f44db6fafcf59ded8ee539cb1" => :yosemite
    sha1 "b9dc272a925a241b44eb4cbcdbca24875148faa0" => :mavericks
    sha1 "a9397e15adb111ad52db175cd7d3221f4ae6f863" => :mountain_lion
  end

  depends_on "nagios-plugins"
  depends_on "openssl"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    inreplace "sample-config/nrpe.cfg.in", "/var/run/nrpe.pid", var+"run/nrpe.pid"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{sbin}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{Formula["openssl"].opt_lib}",
                          "--enable-ssl",
                          "--enable-command-args"
    system "make", "all"
    system "make", "install"
    system "make", "install-daemon-config"
    (var+"run").mkpath
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>org.nrpe.agent</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/bin/nrpe</string>
        <string>-c</string>
        <string>#{etc}/nrpe.cfg</string>
        <string>-d</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>ServiceDescription</key>
      <string>Homebrew NRPE Agent</string>
      <key>Debug</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def caveats
    <<-EOS.undent
    The nagios plugin check_nrpe has been installed in:
      #{HOMEBREW_PREFIX}/sbin

    You can start the daemon with
      #{bin}/nrpe -c #{etc}/nrpe.cfg -d
    EOS
  end
end
