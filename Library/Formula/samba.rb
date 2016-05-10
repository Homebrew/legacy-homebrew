class Samba < Formula
  desc "SMB/CIFS file, print, and login server for UNIX"
  homepage "https://samba.org/"
  url "https://download.samba.org/pub/samba/stable/samba-4.4.0.tar.gz"
  sha256 "c5f6fefb7fd0a4e5f404a253b19b55f74f88faa1c3612cb3329e24aa03470075"

  bottle do
    revision 1
    sha256 "da0c666f7090e0d838a9232e69a6669c27c54ac2f296cdd0fb3267e019abafe9" => :el_capitan
    sha256 "f1fc6a41e7ff919d7c0d2459df72df4dfa84d557481301338cbb74489e80b659" => :yosemite
    sha256 "3fe2b2aa3b3623dd7d8bc3f2ef7308600125eed03817ecf0fa9d10c0c9911705" => :mavericks
    sha256 "f6c02ca7f1dd074a3b5c021810351904cbe8b447bd81adc9598e64e1eb342e10" => :mountain_lion
  end

  conflicts_with "talloc", :because => "both install `include/talloc.h`"

  # Once the smbd daemon is executed with required root permissions
  # contents of these two directories becomes owned by root. Sad face.
  skip_clean "private"
  skip_clean "var/locks"

  depends_on "pkg-config" => :build
  depends_on "docbook-xsl"
  depends_on "gnutls"

  conflicts_with "jena",
    :because => "both install `tdbbackup` and `tdbdump` binaries"

  fails_with :clang

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datadir=#{share}/codepages",
                          "--with-configdir=#{prefix}/etc",
                          "--without-ads",
                          "--without-acl-support",
                          "--without-ldap"

    (prefix/"private").mkpath
    (prefix/"var/locks").mkpath

    system "make"
    system "make", "install"
    # makefile doesn't have an install target for these
    (lib/"pkgconfig").install Dir["pkgconfig/*.pc"]

    # Install basic example configuration
    inreplace "examples/smb.conf.default" do |s|
      s.gsub! "/usr/local/samba/var/log.%m", "#{prefix}/var/log/samba/log.%m"
    end
    (prefix/"etc").install "examples/smb.conf.default" => "smb.conf"
  end

  plist_options :manual => "smbd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/smbd</string>
          <string>-s</string>
          <string>#{etc}/smb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"eventlogadm", "-h"
  end
end
