class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/0.8.18/irssi-0.8.18.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/i/irssi/irssi_0.8.18.orig.tar.gz"
  sha256 "30043784815bb864b1bb66a82c1e659c325be0a18ddcf76fc101812e36c39c20"

  bottle do
    sha256 "877355812fdd1bd4e29725f94f1ad62971c701dd6d67d1da2256a8f79f3af982" => :el_capitan
    sha256 "2cf15f98fe67935a05abcc090e4b99039a5b32419c7cbb373624caa5934fca07" => :yosemite
    sha256 "bbc883c332a9faf34c3a9325ebd9ee9b79ce79303bdefb832da4d516cbff2eec" => :mavericks
  end

  head do
    url "https://github.com/irssi/irssi.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  option "with-dante", "Build with SOCKS support"
  option "without-perl", "Build without perl support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl" => :recommended
  depends_on "dante" => :optional

  def install
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
