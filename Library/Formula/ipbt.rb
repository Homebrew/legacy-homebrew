require 'formula'

class Ipbt < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-r9487.tar.gz'
  sha1 'ff0b306dae14ed6c693331c995410ad8dfc28d02'
  version 'r9487'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end

  def test
    system "#{bin}/ipbt"
  end
end
