require 'formula'

class Pngquant < Formula
  homepage 'http://pngquant.org/'
  url 'https://github.com/pornel/pngquant/archive/2.2.0.tar.gz'
  sha1 'd7ed6f13fdbef52074cbaee5452a2e7e27573376'

  head 'https://github.com/pornel/pngquant.git'

  depends_on 'libpng'

  def install
    ENV.append_to_cflags "-DNDEBUG" # Turn off debug
    system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    bin.install 'pngquant'
    man1.install 'pngquant.1'
  end

  test do
    system "#{bin}/pngquant", "--help"
  end
end
