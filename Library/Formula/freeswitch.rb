class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  url "https://freeswitch.org/stash/scm/fs/freeswitch.git",
      :tag => "v1.4.20",
      :revision => "0ae8ee7f8f13a37cf48381381b2f30906e750e19"

  head "https://freeswitch.org/stash/scm/fs/freeswitch.git"

  bottle do
    sha256 "724b0f3f85c5dde65923d7b64b396addccd898a9b0f8977a422e0518a2a62d94" => :yosemite
    sha256 "f91222c325a6f65da9873559b61912095e23f7bcee0dec1079170b139696e7d2" => :mavericks
    sha256 "5a3cbf979034485152c4412980d62516e12bb6b0a5e52e7c71f636368960ef0d" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :apr => :build

  option "without-moh", "Do not install music-on-hold"
  option "without-sounds-en", "Do not install English (Callie) sounds"
  option "with-sounds-fr", "Install French (June) sounds"
  option "with-sounds-ru", "Install Russian (Elena) sounds"

  depends_on "curl"
  depends_on "jpeg"
  depends_on "ldns"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "speex"
  depends_on "sqlite"

  def install
    system "./bootstrap.sh", "-j"

    # tiff will fail to find OpenGL unless told not to use X
    inreplace "libs/tiff-4.0.2/configure.gnu", "--with-pic", "--with-pic --without-x"

    system "./configure", "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"

    make_targets = %w[install all]
    make_targets << "cd-moh-install" if build.with?("moh")
    make_targets << "cd-sounds-install" if build.with?("sounds-en")
    make_targets << "cd-sounds-fr-install" if build.with?("sounds-fr")
    make_targets << "cd-sounds-ru-install" if build.with?("sounds-ru")

    system "make"
    system "make", *make_targets
  end

  plist_options :manual => "freeswitch -nc --nonat"

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
          <string>#{bin}/freeswitch</string>
          <string>-nc</string>
          <string>-nonat</string>
        </array>
      <key>RunAtLoad</key>
        <true/>
      <key>ServiceIPC</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/freeswitch", "-version"
  end
end
