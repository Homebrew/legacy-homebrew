require 'formula'

class CKermit < Formula
  url 'http://www.kermitproject.org/ftp/kermit/archives/cku302.tar.gz'
  homepage 'http://www.kermitproject.org/'
  md5 'eac4dbf18b45775e4cdee5a7c74762b0'
  version '9.0.302'

  def install
    system "make macosx"
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end
end
