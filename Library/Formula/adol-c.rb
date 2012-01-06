require 'formula'

class AdolC < Formula
  url 'http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.2.1.tgz'
  homepage 'http://www.coin-or.org/projects/ADOL-C.xml'
  md5 '5fe149865b47f77344ff910702da8b99'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
