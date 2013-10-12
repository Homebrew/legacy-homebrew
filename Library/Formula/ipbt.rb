require 'formula'

class Ipbt < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-r9487.tar.gz'
  sha1 '6938c792994473cff2e3cdb44edc957664e6cc83'
  version 'r9487'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end

  def test
    system "#{bin}/ipbt"
  end
end
