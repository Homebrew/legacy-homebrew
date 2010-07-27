require 'formula'

class Dmenu <Formula
  url 'http://dl.suckless.org/tools/dmenu-4.1.1.tar.gz'
  homepage 'http://tools.suckless.org/dmenu/'
  md5 '931896a199741c23be945e8519a81c1d'
  head 'http://hg.suckless.org/dmenu/'

  def install
    system "make PREFIX=#{prefix} install"
  end
end
