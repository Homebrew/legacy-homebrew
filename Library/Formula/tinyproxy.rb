class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://www.banu.com/tinyproxy/"
  url "https://www.banu.com/pub/tinyproxy/1.8/tinyproxy-1.8.3.tar.bz2"
  sha256 "be559b54eb4772a703ad35239d1cb59d32f7cf8a739966742622d57df88b896e"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "004c6319701e7529b252e1860321cf14369a74029a6f05523662365ff1292f1b" => :el_capitan
    sha256 "b68a1b323a20f689b96e7405f2c491c66849fa011beb450dcf417be491557da4" => :yosemite
    sha256 "7bba647101259e9299a8a61177fcba2966b056091e9b1a28a43207e612a0bcfc" => :mavericks
  end

  depends_on "asciidoc" => :build

  option "with-reverse", "Enable reverse proxying"
  option "with-transparent", "Enable transparent proxying"

  deprecated_option "reverse" => "with-reverse"

  # Fix linking error, via MacPorts: https://trac.macports.org/ticket/27762
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/2b17ed2/tinyproxy/patch-configure.diff"
    sha256 "414b8ae7d0944fb8d90bef708864c4634ce1576c5f89dd79539bce1f630c9c8d"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --disable-regexcheck
    ]

    args << "--enable-reverse" if build.with? "reverse"
    args << "--enable-transparent" if build.with? "transparent"

    system "./configure", *args

    # Fix broken XML lint
    # See: https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=154624
    inreplace ["docs/man5/Makefile", "docs/man8/Makefile"] do |s|
      s.gsub! "-f manpage", "-f manpage \\\n  -L"
    end

    system "make", "install"
  end

  def post_install
    (var/"log/tinyproxy").mkpath
    (var/"run/tinyproxy").mkpath
  end

  test do
    pid = fork do
      exec "#{sbin}/tinyproxy"
    end
    sleep 2

    begin
      assert_match /tinyproxy/, shell_output("curl localhost:8888")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end

  plist_options :manual => "tinyproxy"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_sbin}/tinyproxy</string>
            <string>-d</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
