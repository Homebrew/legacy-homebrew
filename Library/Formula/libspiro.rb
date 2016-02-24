class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https://github.com/fontforge/libspiro"
  url "https://downloads.sourceforge.net/project/libspiro/libspiro/20071029/libspiro_src-20071029.tar.bz2"
  sha256 "1efeb1527bd48f8787281e8be1d0e8ff2e584d4c1994a0bc2f6859be2ffad4cf"

  bottle do
    cellar :any
    revision 1
    sha256 "b74aa7a260b965d0910c86eff34bb29268efe56d2050063ad21e5261b7767697" => :el_capitan
    sha256 "bc389fbed945d055b3acac18eeee82d36e4d5174be1b5e42e9759ed09a74dde1" => :yosemite
    sha256 "b7b9bc066871be5999c7c49fa400a3eafa985aefcf1362dd19370981c686db5a" => :mavericks
    sha256 "49ffd6343c706612bfb641a756e31944ee7b712dd25198413150bfd383d907fd" => :mountain_lion
  end

  head do
    url "https://github.com/fontforge/libspiro.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
