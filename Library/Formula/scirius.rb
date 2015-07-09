class Scirius < Formula
  desc "Rules manager for Suricata IDPS"
  homepage "https://github.com/StamusNetworks/scirius"
  url "https://github.com/StamusNetworks/scirius"
  version "1.0."
  sha256 ""

  depends_on :python

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    #system "make", "install" # if this fails, try separate make/make install steps
  end

plist_options :manual => "python"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
        <dict>
            <key>KeepAlive</key>
            <true/>
            <key>Label</key>
            <string>#{plist_name}</string>
            <key>ProgramArguments</key>
            <array>
                <string>#{HOMEBREW_PREFIX}/bin/python</string>
                <string>/usr/local/var/www/scirius/manage.py</string>
                <string>runserver</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
        </dict>
    </plist>
  EOS
  end

  test do
    system "false"
  end
end
