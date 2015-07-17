class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  url "https://freeswitch.org/stash/scm/fs/freeswitch.git",
      :tag => "v1.4.20",
      :revision => "0ae8ee7f8f13a37cf48381381b2f30906e750e19"

  head "https://freeswitch.org/stash/scm/fs/freeswitch.git"

  bottle do
    sha256 "7b39bcf111c401f87c670679b2f9d835c5fd978b36fcb231f930cd4e8d3d2e29" => :yosemite
    sha256 "33b0488bab7fc54d8f5b2bf04039736bf2e602cb1b1b394b069df622e3f4e48e" => :mavericks
    sha256 "5b3d705d9a63e9a4d05a9b42c9de02d0524e0d1357c4ffa83efa1c6b9b85009d" => :mountain_lion
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
