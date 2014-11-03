require 'formula'

class Libgetdata < Formula
  homepage 'http://getdata.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/getdata/getdata/0.8.5/getdata-0.8.5.tar.bz2'
  sha1 '4f509e10f9eb6e8cfc378efd8b483b2a2508917f'

  bottle do
    revision 1
    sha1 "d9e00acda82ad00dad588641771a5768bf297327" => :yosemite
    sha1 "03c0d9b0fa6aa8460ecd0e03fbac525d8b423896" => :mavericks
    sha1 "5622cd622ed77f161f36d7a4bbaf29154c943457" => :mountain_lion
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
