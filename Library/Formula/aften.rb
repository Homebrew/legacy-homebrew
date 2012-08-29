require 'formula'

class Aften < Formula
  homepage 'http://aften.sourceforge.net/'
  url 'http://downloads.sourceforge.net/aften/aften-0.0.8.tar.bz2'
  md5 'fde67146879febb81af3d95a62df8840'

  depends_on 'cmake' => :build

  def install
    mkdir 'default' do
      system "cmake", "-DSHARED=ON", "..", *std_cmake_args
      system "make install"
    end
  end
end
