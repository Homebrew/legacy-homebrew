class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "http://getdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.9.0/getdata-0.9.0.tar.xz"
  sha256 "b38de059ff21df873e95978867eb82f716b89fc7e8e503e2cc7cef93d22685a2"

  bottle do
    sha256 "8cca507b99623199f5cca86fa0c88fad9205b7a41f410af56c150bff5222bb14" => :yosemite
    sha256 "9bb073d0fe1df3fcb50b96b11038f5bc89b97472679456dc5fbac60400307f00" => :mavericks
    sha256 "6bfb2f3c90b58f82a2f08adb9e940b32a46f8d5370a8d6278d31532490dcda31" => :mountain_lion
  end

  option "with-fortran", "Build Fortran 77 bindings"
  option "with-perl", "Build Perl binding"
  option "with-xz", "Build with LZMA compression support"
  option "with-libzzip", "Build with zzip compression support"

  deprecated_option "lzma" => "with-xz"
  deprecated_option "zzip" => "with-libzzip"

  depends_on :fortran => :optional
  depends_on "xz" => :optional
  depends_on "libzzip" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-python
      --disable-php
    ]

    args << "--disable-perl" if build.without? "perl"
    args << "--without-liblzma" if build.without? "xz"
    args << "--without-libzzip" if build.without? "libzzip"
    args << "--disable-fortran" << "--disable-fortran95" if build.without? "fortran"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
