require 'formula'

class Ipbt < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-r9253.tar.gz'
  version 'r9253'
  md5 '4af1feec39b95b437b669e3f1e46d7ef'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/ipbt"
  end
end
