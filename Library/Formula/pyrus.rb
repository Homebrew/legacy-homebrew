require 'formula'

class Pyrus < Formula
  url 'http://packages.zendframework.com/pyrus.phar'
  version '2.0.0a4'
  homepage 'http://pear2.php.net'
  md5 '8592cd8e81252c3fff318d336e5b0e0d'

  def install
    bin.install 'pyrus.phar'
  end

  def test
    system "pyrus.phar --version"
  end
end
