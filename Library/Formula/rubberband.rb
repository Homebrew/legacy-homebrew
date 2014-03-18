require 'formula'

class Rubberband < Formula
  homepage ''
  url 'http://code.breakfastquay.com/attachments/download/34/rubberband-1.8.1.tar.bz2'
  sha1 'ae1faaef211d612db745d66d77266cf6789fd4ee'

  depends_on 'pkg-config'
  depends_on 'libsamplerate'
  depends_on 'vamp-plugin-sdk' => :optional

  def install
    system "make", "-f", "Makefile.osx"
    bin.install "bin/rubberband"
    lib.install "lib/librubberband.dylib"
    include.install Dir['rubberband'] 
  end

  test do
    system "false"
  end
end
