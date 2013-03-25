require 'formula'

class Editorconfig < Formula
  homepage 'http://editorconfig.org'
  url 'https://github.com/editorconfig/editorconfig-core/archive/v0.11.0.zip'
  sha1 'd8a4dbeb3c7098fe3fea78cd54816e64e442dafe'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make install"
  end

  def test
    system "editorconfig"
  end
end
