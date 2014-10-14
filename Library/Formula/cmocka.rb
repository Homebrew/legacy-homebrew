require 'formula'

class Cmocka < Formula
  homepage 'http://cmocka.cryptomilk.org/'
  url 'https://open.cryptomilk.org/attachments/download/42/cmocka-0.4.1.tar.xz'
  sha1 'ef8b64878edc5f0e442dc6aaf3dc83ef912c51c2'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", "-DUNIT_TESTING=On", *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
