require 'formula'

class Libspiff <Formula
  url 'http://downloads.sourceforge.net/project/libspiff/Sources/1.0.0/libspiff-1.0.0.tar.gz'
  homepage 'http://sourceforge.net/projects/libspiff'
  md5 ''

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
