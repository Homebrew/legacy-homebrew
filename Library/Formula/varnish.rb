require 'formula'

class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage 'https://www.varnish-cache.org/'
  url 'https://repo.varnish-cache.org/source/varnish-4.0.3.tar.gz'
  sha1 'ba4668cb7d17f95c4c5e4baf964fe1412a269297'

  bottle do
    sha256 "050160fe3c7780d56f0ff3a68e26c200c72ffb785451d351cb2b1410d7b86588" => :yosemite
    sha256 "204524142865d6ea5fc9d1dec5c877402726ec44133bcc0d1e0aeb31e39730c7" => :mavericks
    sha256 "31c5ee79f9bc61d9951dac9a6f56687b8c2724ff934c90ecfb171687707fd4d3" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.11.tar.gz"
    sha1 "3894ebcbcbf8aa54ce7c3d2c8f05460544912d67"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath+"lib/python2.7/site-packages"
    resource("docutils").stage do
      system "python", "setup.py", "install", "--prefix=#{buildpath}"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-rst2man=#{buildpath}/bin/rst2man.py",
                          "--with-rst2html=#{buildpath}/bin/rst2html.py"
    system "make install"
    (var+'varnish').mkpath
  end

  test do
    system "#{opt_sbin}/varnishd", "-V"
  end

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/varnishd</string>
          <string>-n</string>
          <string>#{var}/varnish</string>
          <string>-f</string>
          <string>#{etc}/varnish/default.vcl</string>
          <string>-s</string>
          <string>malloc,1G</string>
          <string>-T</string>
          <string>127.0.0.1:2000</string>
          <string>-a</string>
          <string>0.0.0.0:80</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/varnish/varnish.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/varnish/varnish.log</string>
      </dict>
      </plist>
    EOS
  end
end
