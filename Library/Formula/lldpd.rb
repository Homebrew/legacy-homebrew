require 'formula'

class Lldpd < Formula
  homepage 'http://vincentbernat.github.io/lldpd/'
  url 'http://media.luffy.cx/files/lldpd/lldpd-0.7.6.tar.gz'
  sha1 'be3d3937b22d14259553f637694f744ed3b8ba79'

  option 'with-snmp', "Build SNMP subagent support"
  option 'with-json', "Build JSON support for lldpcli"

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'libevent'
  depends_on 'net-snmp' if build.include? 'with-snmp'
  depends_on 'jansson'  if build.include? 'with-json'

  # Don't try to install provided launchd plist (outside of prefix)
  # Being addressed upstream for next release.
  def patches
    "https://raw.github.com/vincentbernat/lldpd/91a63c540e59871001b04a43a784935533fd167a/osx/dont-install-launchd-plist.patch"
  end

  def install
    readline = Formula.factory 'readline'
    args = [ "--prefix=#{prefix}",
             "--with-xml",
             "--with-readline",
             "--with-privsep-chroot=/var/empty",
             "--with-privsep-user=nobody",
             "--with-privsep-group=nogroup",
             "CPPFLAGS=-I#{readline.include} -DRONLY=1",
             "LDFLAGS=-L#{readline.lib}" ]
    args << "--with-snmp" if build.include? 'with-snmp'
    args << "--with-json" if build.include? 'with-json'

    system "./configure", *args
    system "make"
    system "make install"
  end

  plist_options :startup => true

  def plist
    additional_args = ""
    if build.include? 'with-snmp'
      additional_args += "<string>-x</string>"
    end
    return <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/lldpd</string>
        #{additional_args}
      </array>
      <key>RunAtLoad</key><true/>
      <key>KeepAlive</key><true/>
    </dict>
    </plist>
    EOS
  end

end
