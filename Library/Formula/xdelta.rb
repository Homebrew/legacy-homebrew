require 'formula'

class Xdelta < Formula
  url 'http://xdelta.googlecode.com/files/xdelta3.0.0.tar.gz'
  homepage 'http://xdelta.org'
  sha1 'c9e54fd8dbd9f2e77ead17be9d00e0b8af109024'

  def install
    system "make"
    bin.install "xdelta3"
    man1.install "xdelta3.1"
  end
end
