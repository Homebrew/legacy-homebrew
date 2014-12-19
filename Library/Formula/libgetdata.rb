require 'formula'

class Libgetdata < Formula
  homepage 'http://getdata.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/getdata/getdata/0.8.5/getdata-0.8.5.tar.bz2'
  sha1 '4f509e10f9eb6e8cfc378efd8b483b2a2508917f'
  revision 1

  bottle do
    sha1 "845fc0330d8e4ae33987e898c1cbf20d7217b847" => :yosemite
    sha1 "016aaefb4e68d95604d454545bf25eb1d4f34205" => :mavericks
    sha1 "1787e29cddbfd694b15860d0af697657d0602210" => :mountain_lion
  end

  option 'with-fortran', 'Build Fortran 77 bindings'
  option 'with-perl', 'Build Perl binding'
  option 'lzma', 'Build with LZMA compression support'
  option 'zzip', 'Build with zzip compression support'

  depends_on :fortran => :optional
  depends_on 'xz' if build.include? 'lzma'
  depends_on 'libzzip' if build.include? 'zzip'


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
