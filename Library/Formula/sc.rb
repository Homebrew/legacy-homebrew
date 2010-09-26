require 'formula'

class Sc <Formula
  url 'http://metalab.unc.edu/pub/linux/apps/financial/spreadsheet/sc-7.16.tar.gz'
  homepage 'http://www.ibiblio.org/pub/linux/apps/financial/spreadsheet/sc-7.16.lsm'
  md5 '1db636e9b2dc7cd73c40aeece6852d47'

  def install
    system "ln -s /usr/local/share/man/ /usr/man"
    system "make install"
  end
end
