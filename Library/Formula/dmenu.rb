require 'formula'

class Dmenu <Formula
  url 'http://dl.suckless.org/tools/dmenu-4.0.tar.gz'
  homepage 'http://tools.suckless.org/dmenu/'
  md5 '66e761a653930cc8a21614ba9fedf903'
  head 'http://hg.suckless.org/dmenu/'

  def install
    system "make PREFIX=#{prefix} install"
  end
end
