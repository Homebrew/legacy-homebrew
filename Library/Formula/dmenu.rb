require 'formula'

class Dmenu < Formula
  url 'http://dl.suckless.org/tools/dmenu-4.4.1.tar.gz'
  homepage 'http://tools.suckless.org/dmenu/'
  md5 'd18aaa9ac3265f92ec34a0df0cb6ebd4'
  head 'http://hg.suckless.org/dmenu/'

  def install
    system "make PREFIX=#{prefix} install"
  end
end
