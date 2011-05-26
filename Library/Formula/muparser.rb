require 'formula'

class Muparser < Formula
  url 'http://sourceforge.net/projects/muparser/files/muparser/Version%201.34/muparser_v134.tar.gz'
  homepage 'http://muparser.sourceforge.net/'
  md5 '0c4f4bf86aa2a5a737adc0e08cb77737'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
