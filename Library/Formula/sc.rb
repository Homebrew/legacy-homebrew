require 'formula'

class Sc <Formula
  url 'http://www.ibiblio.org/pub/linux/apps/financial/spreadsheet/sc-7.16.tar.gz'
  homepage 'http://www.ibiblio.org/pub/linux/apps/financial/spreadsheet/sc-7.16.lsm'
  md5 '1db636e9b2dc7cd73c40aeece6852d47'

  def install
    inreplace 'Makefile', '/man/man1', '/share/man/man1'
    bin.mkpath
    lib.mkpath
    man1.mkpath
    system "make prefix=#{prefix} install"
  end
end
