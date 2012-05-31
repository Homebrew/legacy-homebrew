require 'formula'

class Sic < Formula
  url 'http://dl.suckless.org/tools/sic-1.1.tar.gz'
  md5 '856d0e5faa151ae9602713ee7d34a2d5'
  head 'http://hg.suckless.org/sic', :using => :hg
  homepage 'http://tools.suckless.org/sic'

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
