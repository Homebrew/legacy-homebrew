require 'formula'

class Freeswitch < Formula
  homepage 'http://freeswitch.org'
  url 'https://stash.freeswitch.org/scm/fs/freeswitch.git', :tag => 'v1.4.6'

  head 'https://stash.freeswitch.org/scm/fs/freeswitch.git'

  bottle do
    sha1 "a1ff029908457b7a992474b8abd4428c88858128" => :mavericks
    sha1 "05c391e0c3f2f795ec7b87485a5ad54fbdd57259" => :mountain_lion
    sha1 "dc5a331f94eb51353d01dfe6d2319985e7844a96" => :lion
  end

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build

  depends_on 'jpeg'
  depends_on 'curl'
  depends_on 'openssl'
  depends_on 'pcre'
  depends_on 'speex'
  depends_on 'sqlite'

  def install
    system "./bootstrap.sh -j#{ENV.make_jobs}"

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
    system "make install"
    system "make all cd-sounds-install cd-moh-install"
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
