class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/0.8.19/irssi-0.8.19.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/irssi/irssi_0.8.19.orig.tar.gz"
  sha256 "fe4f4b778698de8e1c319b9cd9b9ed5534f0ece7ac2bfa0af351a3157c6ec85b"

  bottle do
    sha256 "d23b2fcfffaec2ff7b06d333522f2fc595f16f25db6034ba3ce557d71c934949" => :el_capitan
    sha256 "42100f71db945875b591b92e2e410c84ac9fa88609270782fe1998811fe84804" => :yosemite
    sha256 "45d0e499afa6bacbc98533588da326418de72f2b2f7cebff64edfee25b0d3011" => :mavericks
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
