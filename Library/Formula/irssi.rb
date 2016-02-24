class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi-import/irssi/releases/download/0.8.17/irssi-0.8.17.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/i/irssi/irssi_0.8.17.orig.tar.gz"
  sha256 "0ae01f76797fb6d6b8e0f2268b39c7afb90ac62658ec754c82acfc344b8203e9"
  revision 2

  head do
    url "https://github.com/irssi/irssi.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  bottle do
    revision 3
    sha256 "3c70f0936f14cf71dcefdbd635e825ef0941a9c44e6693ae495cc68382c751bc" => :el_capitan
    sha256 "b55f35cd938692dd577d553c3a6b48f89b5923125a96fa23697ab162d2a7cb61" => :yosemite
    sha256 "1b30b5687ad71c6cb74ba6264673bc6244c053c30773a145f3cb008500989c9f" => :mavericks
  end

  option "with-dante", "Build with SOCKS support"
  option "without-perl", "Build without perl support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl" => :recommended
  depends_on "dante" => :optional

  def install
    if build.stable?
      # Make paths in man page Homebrew-specific
      # (https://github.com/irssi/irssi/issues/251); can be removed in
      # next stable release
      inreplace "docs/irssi.1" do |s|
        s.gsub! "/usr/share", "#{HOMEBREW_PREFIX}/share"
        s.gsub! "/etc/irssi.conf", "#{HOMEBREW_PREFIX}/etc/irssi.conf"
      end
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-ipv6
      --enable-true-color
      --with-socks=#{build.with?("dante") ? "yes" : "no"}
      --with-ncurses=#{MacOS.sdk_path}/usr
    ]

    if build.with? "perl"
      args << "--with-perl=yes"
      args << "--with-perl-lib=#{lib}/perl5/site_perl"
    else
      args << "--with-perl=no"
    end

    args << "--disable-ssl" if build.without? "openssl"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irssi --connect=irc.freenode.net", "w") do |pipe|
      pipe.puts "/quit\n"
      pipe.close_write
    end
  end
end
