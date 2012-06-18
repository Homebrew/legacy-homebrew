require 'formula'

class Xdelta < Formula
  homepage 'http://xdelta.org'
  url 'http://xdelta.googlecode.com/files/xdelta3.0.0.tar.gz'
  sha1 'c9e54fd8dbd9f2e77ead17be9d00e0b8af109024'

  fails_with :clang do
    build 318
    cause "Undefined symbols for architecture x86_64: \"_xd3_source_eof\""
  end

  def install
    system "make"
    bin.install "xdelta3"
    man1.install "xdelta3.1"
  end
end
