class Dovecot < Formula
  homepage "http://dovecot.org/"
  url "http://dovecot.org/releases/2.2/dovecot-2.2.16.tar.gz"
  mirror "https://fossies.org/linux/misc/dovecot-2.2.16.tar.gz"
  sha256 "56ce1287a17fa88a2083116db00200deff1a5390af5eac1c8ae3f59a2079cff0"

  bottle do
    sha1 "3fce7a1596555dbd75ba1877b36e99bebd8ed364" => :yosemite
    sha1 "fea3e6ba9b1804d87eb7de381ff54377afb7a5a8" => :mavericks
    sha1 "c347ece69c0d20b7849e656568364af02b042c3c" => :mountain_lion
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
