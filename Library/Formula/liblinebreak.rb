require 'formula'

class Liblinebreak <Formula
  url 'http://downloads.sourceforge.net/project/vimgadgets/liblinebreak/2.0/liblinebreak-2.0.tar.gz'
  homepage 'http://vimgadgets.sourceforge.net/liblinebreak/'
  version '2.0'
  md5 'c4ac2052b9e1883822662ecee483c542'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
