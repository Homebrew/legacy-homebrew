class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "http://dovecot.org/"
  url "http://dovecot.org/releases/2.2/dovecot-2.2.16.tar.gz"
  mirror "https://fossies.org/linux/misc/dovecot-2.2.16.tar.gz"
  sha256 "56ce1287a17fa88a2083116db00200deff1a5390af5eac1c8ae3f59a2079cff0"

  bottle do
    sha256 "c7e6a66e2c2feeaee294ce730d839476ea2ee8f6bd6e0be15d3de7f51d0c7c91" => :yosemite
    sha256 "2f06258ea249f6f74d5ac21eb91456800936949ee9d92ce59baf524684c4c596" => :mavericks
    sha256 "4dc666bce910531c1696c36b4082f69f6f0102cbc543c60595c686d7cc5fe45f" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "clucene" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-ssl=openssl
      --with-sqlite
      --with-zlib
      --with-bzlib
    ]

    args << "--with-lucene" if build.with? "clucene"

    system "./configure",  *args
    system "make", "install"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>OnDemand</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dovecot</string>
          <string>-F</string>
        </array>
        <key>ServiceDescription</key>
        <string>Dovecot mail server</string>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    For Dovecot to work, you may need to create a dovecot user
    and group depending on your configuration file options.
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{sbin}/dovecot --version")
  end
end
