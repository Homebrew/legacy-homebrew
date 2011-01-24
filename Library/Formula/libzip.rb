require 'formula'

class Libzip <Formula
  url 'http://www.nih.at/libzip/libzip-0.9.3.tar.bz2'
  homepage 'http://www.nih.at/libzip/'
  md5 '27610091ca27bf843a6646cd05de35b9'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "CXX=#{ENV.cxx}", "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end
end
