require 'formula'

class Ipbt < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-r9487.tar.gz'
  sha1 'cd7c0b991a9422ed5f31ce13846f28fb5860b0dc'
  version 'r9487'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
