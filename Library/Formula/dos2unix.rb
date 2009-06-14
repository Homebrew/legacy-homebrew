require 'brewkit'

class Dos2unix <Formula
  @url='http://www.sfr-fresh.com/linux/misc/dos2unix-3.1.tar.gz'
  @md5='25ff56bab202de63ea6f6c211c416e96'
  @homepage='http://www.sfr-fresh.com/linux/misc/'

  def install
    system "make clean"
    system "make"
    # make install is broken due to INSTALL file, but also it sucks so we'll do it
    bin.install ['dos2unix', 'mac2unix']
    man1.install ['dos2unix.1', 'mac2unix.1']
  end
end
