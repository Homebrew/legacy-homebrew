require 'formula'

class Aften < Formula
  homepage 'http://aften.sourceforge.net/'
  url 'http://downloads.sourceforge.net/aften/aften-0.0.8.tar.bz2'
  sha1 '1ff73cdcade0624495ad807492cecf14862fb61c'

  depends_on 'cmake' => :build

  def install
    mkdir 'default' do
      system "cmake", "-DSHARED=ON", "..", *std_cmake_args
      system "make install"
    end
  end
end
