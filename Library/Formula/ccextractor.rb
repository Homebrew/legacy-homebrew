require 'formula'

class Ccextractor < Formula
  homepage 'http://ccextractor.sourceforge.net/'
  url 'http://sourceforge.net/projects/ccextractor/files/ccextractor/0.64/ccextractor.src.0.64.zip/'
  sha1 '72216b2342f27bb931cdb7239a05f7894fca7150'

  def install
    cd "mac"
    system "bash ./build.command"
    bin.install "ccextractor"
  end
end
