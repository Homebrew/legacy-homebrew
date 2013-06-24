require 'formula'

class Ccextractor < Formula
  homepage 'http://ccextractor.sourceforge.net/'
  url 'http://sourceforge.net/projects/ccextractor/files/ccextractor/0.65/ccextractor.src.0.65.zip'
  sha1 'a6d2ccd5f93459bd220f49db2b0ae437bfd7ec01'

  def install
    cd "mac"
    system "bash ./build.command"
    bin.install "ccextractor"
  end
end
