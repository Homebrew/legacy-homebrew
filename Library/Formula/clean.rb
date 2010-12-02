require 'formula'

class Clean <Formula
  url 'http://downloads.sourceforge.net/project/clean/clean/3.4/clean-3.4.tar.bz2'
  homepage 'http://clean.sourceforge.net/'
  md5 '7edc1f9c7c1fc33298fec329cf5dba01'

  def install
    system 'make'
    bin.install 'clean'
    man1.install 'clean.1'
  end
end
