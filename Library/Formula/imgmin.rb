class Imgmin < Formula
  homepage "https://github.com/rflynn/imgmin"
  url "https://github.com/rflynn/imgmin/archive/v1.1.tar.gz"
  sha256 "62430d42998795e95b92734b7b3272f1329e6c9b3d90b8fdc2ff3cad17ac89ee"
  head "https://github.com/rflynn/imgmin.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "perlmagick"

  def install
    # Apache mod build failure on OS X
    # https://github.com/rflynn/imgmin/issues/34
    inreplace "configure.ac", 'AC_CHECK_PROGS(APXS, apxs2 apxs, "")', ""

    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
