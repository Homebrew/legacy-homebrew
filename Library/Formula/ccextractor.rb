require 'formula'

class Ccextractor < Formula
  homepage 'http://ccextractor.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ccextractor/ccextractor/0.67/ccextractor.src.0.67.zip'
  sha1 '9d3cb3a89f4d65d04415051555d5aee14e29e79b'

  def install
    cd "mac"
    system "bash ./build.command"
    bin.install "ccextractor"
  end
end
