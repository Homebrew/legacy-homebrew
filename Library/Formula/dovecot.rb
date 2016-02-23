class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "http://dovecot.org/"
  url "http://dovecot.org/releases/2.2/dovecot-2.2.21.tar.gz"
  mirror "https://fossies.org/linux/misc/dovecot-2.2.21.tar.gz"
  sha256 "7ab7139e59e1f0353bf9c24251f13c893cf1a6ef4bcc47e2d44de437108d0b20"

  bottle do
    revision 2
    sha256 "280a50a51c3025c49cbb8682baa39c512451ec5c3d7ea4be119a1351b14e925b" => :el_capitan
    sha256 "4c9e79a80a3f696f87e9ce4e94015cd3c131f43253d7f546792fefecca461fd9" => :yosemite
    sha256 "84d4d5d7f6aa337c0ef0e79af8576fbda93d2c41e1940509dd6bcd8b34b58f80" => :mavericks
  end

  option "with-pam", "Build with PAM support"
  option "with-pigeonhole", "Add Sieve addon for Dovecot mailserver"
  option "with-pigeonhole-unfinished-features", "Build unfinished new Sieve addon features/extensions"
  option "with-stemmer", "Build with libstemmer support"

  depends_on "openssl"
  depends_on "clucene" => :optional

  resource "pigeonhole" do
    url "http://pigeonhole.dovecot.org/releases/2.2/dovecot-2.2-pigeonhole-0.4.12.tar.gz"
    sha256 "98a2fd79b0d9effd08c0caf04d483b1caa5e4503dae811e6d436948557bfb702"
  end

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
      :revision => "3b1f4c2ac4b924bb429f929d9decd3f50662a6e0"
  end

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
    args << "--with-pam" if build.with? "pam"

    if build.with? "stemmer"
      args << "--with-libstemmer"

      resource("stemmer").stage do
        system "make", "dist_libstemmer_c"
        system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
      end
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "pigeonhole"
      resource("pigeonhole").stage do
        args = %W[
          --disable-dependency-tracking
          --with-dovecot=#{lib}/dovecot
          --prefix=#{prefix}
        ]

        args << "--with-unfinished-features" if build.with? "pigeonhole-unfinished-features"

        system "./configure", *args
        system "make"
        system "make", "install"
      end
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dovecot</string>
          <string>-F</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/dovecot/dovecot.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/dovecot/dovecot.log</string>
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
