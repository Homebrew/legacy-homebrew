class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  url "https://freeswitch.org/stash/scm/fs/freeswitch.git",
      :tag => "v1.4.19",
      :revision => "ebf2df68fa6f341311620c6d90f5a8d77334606c"

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

  depends_on "jpeg"
  depends_on "curl"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "speex"
  depends_on "sqlite"

  def install
    system "./bootstrap.sh", "-j#{ENV.make_jobs}"

    # tiff will fail to find OpenGL unless told not to use X
    inreplace "libs/tiff-4.0.2/configure.gnu", "--with-pic", "--with-pic --without-x"
    # mod_enum requires libldns-dev which doesn't seem to exist in brew
    inreplace "modules.conf", "applications/mod_enum", "#applications/mod_enum"

    system "./configure", "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"

    system "make"
    system "make", "install", "all", "cd-sounds-install", "cd-moh-install"
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
