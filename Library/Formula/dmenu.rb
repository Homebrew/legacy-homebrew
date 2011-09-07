require 'formula'

class Dmenu < Formula
  url 'http://dl.suckless.org/tools/dmenu-4.4.tar.gz'
  homepage 'http://tools.suckless.org/dmenu/'
  md5 'ae1902fc37716f739836fddce6123ebc'
  head 'http://hg.suckless.org/dmenu/'

  def install
    system "make PREFIX=#{prefix} install"
  end
end
