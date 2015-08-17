class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz"
  sha256 "66383b7d367de25ba031d37762d83e2b55de010c573009c6f58270b137131072"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "66602b7dff3b178bc40e463dcd32c9f62d3373fe85c8bf1f4e0f4f0a2f242b8a" => :yosemite
    sha256 "9da1efed0c4792e156388dfafcb679b23a35b358552d76095838deae14de6a86" => :mavericks
    sha256 "f8db970188a4e10c4cb1610dd32cdb1b45093279ce03bc9ce6f4d19a40b813ec" => :mountain_lion
  end

  depends_on "nagios-plugins"
  depends_on "openssl"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    (var/"run").mkpath
    inreplace "sample-config/nrpe.cfg.in", "/var/run/nrpe.pid", var/"run/nrpe.pid"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{sbin}",
                          "--sysconfdir=#{etc}",
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
