require 'formula'

class CKermit < Formula
  url 'ftp://kermit.columbia.edu/kermit/archives/cku300.tar.gz'
  homepage 'http://www.columbia.edu/kermit/'
  md5 'cde4676b0a31cdb3afa42e10fa81105f'
  version '9.0'

  def install
    system "make macosx"
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end
end
