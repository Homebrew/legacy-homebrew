require 'formula'

class Sic < Formula
  homepage 'http://tools.suckless.org/sic'
  url 'http://dl.suckless.org/tools/sic-1.2.tar.gz'
  sha1 'a91a603d536ae9cff9a806d6b2737053d262e722'

  head 'http://git.suckless.org/sic', :using => :git

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
