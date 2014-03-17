require 'formula'

class BoostBuild < Formula
  homepage 'http://boost.org/boost-build2/'
  url 'https://github.com/boostorg/build/archive/boost-1.55.0.tar.gz'
  sha1 '9daf7587b017716ffd164bcf11d82c4ac00c8ca0'

  head 'https://github.com/boostorg/build.git'

  def install
    if build.head?
      system "./bootstrap.sh"
      system "./b2", "--prefix=#{prefix}", "install"
    else
      cd 'v2' do
        system "./bootstrap.sh"
        system "./b2", "--prefix=#{prefix}", "install"
      end
    end
  end
end
