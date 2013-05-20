require 'formula'

class Editorconfig < Formula
  homepage 'http://editorconfig.org'
  url 'https://github.com/editorconfig/editorconfig-core/archive/v0.11.3.zip'
  sha1 '0e22a7d7b2402886d0efc0b2b36968df73863eda'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/editorconfig"
  end
end
