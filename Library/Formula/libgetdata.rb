require 'formula'

class Libgetdata < Formula
  homepage 'http://getdata.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/getdata/getdata/0.8.5/getdata-0.8.5.tar.bz2'
  sha1 '4f509e10f9eb6e8cfc378efd8b483b2a2508917f'

  bottle do
    sha1 "0d4b1f175a33705e3af00aa161f8717f6c8de741" => :mavericks
    sha1 "bffd13227cd91f16dae58b5de0a3c536e14e22fa" => :mountain_lion
    sha1 "f9f3a979884fa23098fd10c6b780b96b42baee8e" => :lion
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
