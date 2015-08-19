class Irssi < Formula
  desc "Modular IRC client"
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
    revision 2
    sha256 "a3f40b5a09cd11ee4fe46420b03fe8ac99c1603ac560cdd56b373745d5a07b6b" => :yosemite
    sha256 "58a876749226ac7f862bdd8ba2d8c1b3aa9f5f9e9bc69e6d7671a32899b108e8" => :mavericks
    sha256 "dbe24bf6031f96b060884f07dcfc33e00fca993001c3676ce949f6f00522ba88" => :mountain_lion
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
