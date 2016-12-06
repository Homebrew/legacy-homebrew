require 'formula'

class Libzxing < Formula
  url 'https://github.com/jgdavey/zxing-cpp/tarball/zxing-cpp-1.0.1'
  homepage 'https://github.com/jgdavey/zxing-cpp'
  version '1.0.1'
  md5 'f890dbbe286602553dcfc3e9e397893e'

  def install
    system "make"
    system "make install 'PREFIX=#{prefix}'"
    # prefix.install Dir['*']
  end
end
