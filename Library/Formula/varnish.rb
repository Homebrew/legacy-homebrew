require 'formula'

class Varnish < Formula
  homepage 'http://www.varnish-cache.org/'
  url 'https://repo.varnish-cache.org/source/varnish-4.0.0.tar.gz'
  sha1 '6ad4fcf42a505a748ae993cb6ed579159e023633'

  bottle do
    sha1 "190bba2cf0e521b489cbd64cc698ba769b18cccd" => :mavericks
    sha1 "fd12d468c2328179bd402f1592b65ef69d6f1baa" => :mountain_lion
    sha1 "0e9717e705541a34906947eb7e49ab800204e2ff" => :lion
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
