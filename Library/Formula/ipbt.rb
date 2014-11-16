require 'formula'

class Ipbt < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-r9487.tar.gz'
  sha1 'cd7c0b991a9422ed5f31ce13846f28fb5860b0dc'
  version 'r9487'

  bottle do
    cellar :any
    sha1 "979bc5d479a2a232c45301737133bd008e50214a" => :mavericks
    sha1 "556a13b85150ca19aaab8915d2d107d9101e1abd" => :mountain_lion
    sha1 "9ddf633e6a677e4818b14788bf13c3263fd3e85d" => :lion
  end

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
