require 'formula'

class CKermit < Formula
  url 'ftp://kermit.columbia.edu/kermit/archives/cku211.tar.gz'
  homepage 'http://www.columbia.edu/kermit/'
  md5 '5767ec5e6ff0857cbfe2d3ec1ee0e2bc'
  version '8.0.211'

  def install
    system "make macosx103"
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end
end
