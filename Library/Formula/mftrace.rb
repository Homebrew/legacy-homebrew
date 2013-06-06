require 'formula'

class Mftrace < Formula
  homepage 'http://lilypond.org/mftrace/'
  url 'http://lilypond.org/download/sources/mftrace/mftrace-1.2.18.tar.gz'
  sha1 '8ae5c69a49f3d34e021913b6378056a6d43c2fd2'

  depends_on 'potrace'
  depends_on 't1utils'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
