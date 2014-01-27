require "formula"

class Pyrus < Formula
  homepage "http://pear2.php.net/"
  url "https://github.com/pyrus/Pyrus/archive/Pyrus-2.0.0a4.tar.gz"
  sha1 "bf075627e0522d1acc4b443e5ff34a769c3d91cd"

  head "https://github.com/pyrus/Pyrus.git"

  def install
    bin.install 'pyrus.phar'
  end
end
