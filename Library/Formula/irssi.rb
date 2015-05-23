class Irssi < Formula
  homepage "http://irssi.org/"
  url "http://irssi.org/files/irssi-0.8.17.tar.gz"
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
    revision 1
    sha256 "55bdbcb5958fdfd443229dbf67163a2bd5723bcac2b9f624a1e220479a3efab8" => :yosemite
    sha256 "099ed90249fa060d6227163b01f64621b130c55e110e86a521b258d445e98ecb" => :mavericks
    sha256 "a4393b3c87ce4683c92909eb090fb85e972a5dcaded6603c2ab6e1b5e05751b4" => :mountain_lion
  end

  option "without-perl", "Build without perl support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl" => :recommended
  depends_on "dante" => :optional

  def install
    # Make paths in man page Homebrew-specific
    # https://github.com/irssi/irssi/issues/251
    inreplace "docs/irssi.1" do |s|
      s.gsub! "/usr/share", "#{HOMEBREW_PREFIX}/share"
      s.gsub! "/etc/irssi.conf", "#{HOMEBREW_PREFIX}/etc/irssi.conf"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-ipv6
      --enable-true-color
      --with-socks
      --with-ncurses=#{MacOS.sdk_path}/usr
    ]

    if build.with? "perl"
      args << "--with-perl=yes"
      args << "--with-perl-lib=#{lib}/perl5/site_perl"
    else
      args << "--with-perl=no"
    end

    # confuses Perl library path configuration
    # https://github.com/Homebrew/homebrew/issues/34685
    ENV.delete "PERL_MM_OPT"

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
