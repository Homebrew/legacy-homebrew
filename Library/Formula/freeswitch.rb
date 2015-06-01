class Freeswitch < Formula
  homepage "https://freeswitch.org"
  url "https://freeswitch.org/stash/scm/fs/freeswitch.git",
      :tag => "v1.4.19",
      :revision => "ebf2df68fa6f341311620c6d90f5a8d77334606c"

  head "https://freeswitch.org/stash/scm/fs/freeswitch.git"

  bottle do
    sha1 "4e9636023d8cc82441b3594a4cd83d581990e718" => :yosemite
    sha1 "5b80a6caa21ea19eb803c722ca94e42a9696f5ab" => :mavericks
    sha1 "909b8b27c3c98c9f63d47bdc3ec60a30a953842d" => :mountain_lion
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
