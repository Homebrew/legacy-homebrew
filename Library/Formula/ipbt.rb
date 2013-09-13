require 'formula'

class Ipbt < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-r9487.tar.gz'
  sha1 '61fc1aa768c8177088e3c0c50824af731d57fa24'
  version 'r9487'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end

  def test
    system "#{bin}/ipbt"
  end
end
