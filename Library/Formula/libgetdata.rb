class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "http://getdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.9.0/getdata-0.9.0.tar.xz"
  sha256 "b38de059ff21df873e95978867eb82f716b89fc7e8e503e2cc7cef93d22685a2"

  bottle do
    cellar :any
    sha256 "cb9eeb31d322ae668aa42808d3dfabd871bfead6a7b1d82e51493e4c3acd0cd7" => :el_capitan
    sha256 "eda5fc0d909f1ab30370e714730d270b2c8881653b61fd239e795a3152a51f31" => :yosemite
    sha256 "54dc79a3ea3c5a3f783917342bfb724bfbbd9fbe3139f78a002d929223416255" => :mavericks
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
