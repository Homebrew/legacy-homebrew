class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "http://getdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.8.6/getdata-0.8.6.tar.bz2"
  sha256 "e8d333b89abc5b20e2ecc3df4de26338dce8eb2f20677e0636649c6a1ef6b5b3"

  bottle do
    sha256 "8cca507b99623199f5cca86fa0c88fad9205b7a41f410af56c150bff5222bb14" => :yosemite
    sha256 "9bb073d0fe1df3fcb50b96b11038f5bc89b97472679456dc5fbac60400307f00" => :mavericks
    sha256 "6bfb2f3c90b58f82a2f08adb9e940b32a46f8d5370a8d6278d31532490dcda31" => :mountain_lion
  end

  option "with-fortran", "Build Fortran 77 bindings"
  option "with-perl", "Build Perl binding"
  option "lzma", "Build with LZMA compression support"
  option "zzip", "Build with zzip compression support"

  depends_on :fortran => :optional
  depends_on "xz" if build.include? "lzma"
  depends_on "libzzip" if build.include? "zzip"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-perl" if build.without? "perl"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
