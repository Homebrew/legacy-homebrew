require 'formula'

class Ccextractor < Formula
  homepage 'http://ccextractor.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.69/ccextractor.src.0.69.zip'
  sha1 '684261cfc86ece2da8b63341fb0058dc66f92119'

  def install
    cd "mac"
    system "bash ./build.command"
    bin.install "ccextractor"
  end
end
