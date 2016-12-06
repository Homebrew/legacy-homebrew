require 'formula'

class Ipbt < Formula
  url 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-r9253.tar.gz'
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/'
  md5 'fc91919f4663fbd66457427402b3e4ea'
  version 'r9253'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/ipbt"
  end
end
