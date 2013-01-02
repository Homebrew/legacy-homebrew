require 'formula'

class Editorconfig < Formula
  homepage 'http://editorconfig.org'
  url 'https://github.com/editorconfig/editorconfig-core/tarball/v0.10.0'
  sha1 'afae2e81cf130a0d1f9fbbcdd5e2ef5953af8bdc'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make install"
  end

  def test
    system "editorconfig"
  end
end
