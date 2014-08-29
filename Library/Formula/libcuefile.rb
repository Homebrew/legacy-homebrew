require 'formula'

class Libcuefile < Formula
  homepage 'http://www.musepack.net/'
  url 'http://files.musepack.net/source/libcuefile_r475.tar.gz'
  sha1 'd7363882384ff75809dc334d3ced8507b81c6051'
  version 'r475'

  bottle do
    cellar :any
    sha1 "3eb4ffc2e18ee23c12e0ab7e204ddde466506cda" => :mavericks
    sha1 "a7924909d23a1db55ce783111753e98ae7cd8214" => :mountain_lion
    sha1 "7809a1d87c1b7f8489cbab02e89a59a9d34b3213" => :lion
  end

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    include.install 'include/cuetools/'
  end
end
