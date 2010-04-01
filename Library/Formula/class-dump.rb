require 'formula'

class ClassDump <Formula
  url 'http://www.codethecode.com/download/class-dump-3.3.1.tar.bz2'
  homepage 'http://www.codethecode.com/projects/class-dump/'
  md5 '52e8d718d5087e9873f2c8880dcbd6f6'

  skip_clean "bin/class-dump"

  def install
    bin.install 'class-dump'
  end
end
