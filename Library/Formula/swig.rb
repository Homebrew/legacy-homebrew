require 'formula'

class Swig <Formula
  url 'http://prdownloads.sourceforge.net/swig/swig-2.0.0.tar.gz'
  homepage ''
  md5 ''

# depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
#   system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
