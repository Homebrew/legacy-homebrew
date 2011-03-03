require 'formula'

class Dmenu <Formula
  url 'http://dl.suckless.org/tools/dmenu-4.2.1.tar.gz'
  homepage 'http://tools.suckless.org/dmenu/'
  md5 '5c95f974fa0c723f46838d0d5fbf5aca'
  head 'http://hg.suckless.org/dmenu/'

  def install
    system "make PREFIX=#{prefix} install"
  end
end
