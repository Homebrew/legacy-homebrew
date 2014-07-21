require 'formula'

class Taglib < Formula
  homepage 'http://taglib.github.io/'
  url 'https://github.com/taglib/taglib/archive/v1.9.1.tar.gz'
  sha1 '44165eda04d49214a0c4de121a4d99ae18b9670b'

  bottle do
    cellar :any
    sha1 "ffb7b35a5c94069ff5d9891f1f94aa5c555e7abc" => :mavericks
    sha1 "c6487d4a603c82d912a6ae5925050f27a656f658" => :mountain_lion
    sha1 "c28943778af7de98937e3bb3c96d408d334ee619" => :lion
  end

  depends_on 'cmake' => :build

  def install
    ENV.append 'CXXFLAGS', "-DNDEBUG=1"
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", *std_cmake_args
    system "make"
    system "make install"
  end
end
