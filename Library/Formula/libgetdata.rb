class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "http://getdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.8.6/getdata-0.8.6.tar.bz2"
  sha1 "57f12393916a658123c759d04ed88fe0348cbac6"

  bottle do
    sha1 "b61a26ca98f6c5b6ee39a0830596f444a8cc51cb" => :yosemite
    sha1 "233d08e7430bccc79843d7e2b7fa52ce70077ef7" => :mavericks
    sha1 "44b04b72452d00f50e600a7c2774e8dfb254ddaa" => :mountain_lion
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
