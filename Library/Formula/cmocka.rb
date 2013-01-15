require 'formula'

class Cmocka < Formula
  homepage 'http://cmocka.cryptomilk.org/'
  url 'https://open.cryptomilk.org/attachments/download/7/cmocka-0.2.0.tar.gz'
  sha1 '6d3aa2c201cb390d6bf5929eba75d9e77bfe4159'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", "-DUNIT_TESTING=On", *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
