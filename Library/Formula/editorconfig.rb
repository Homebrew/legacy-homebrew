require 'formula'

class Editorconfig < Formula
  homepage 'http://editorconfig.org'
  url 'https://github.com/editorconfig/editorconfig-core/archive/v0.11.3.zip'
  sha1 '9e0c22e863dfb8b97526812ebe7c58c46604ebb8'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/editorconfig"
  end
end
