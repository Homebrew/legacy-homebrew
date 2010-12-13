require 'formula'

class Mftrace <Formula
  url 'http://lilypond.org/download/sources/mftrace/mftrace-1.2.16.tar.gz'
  homepage 'http://lilypond.org/mftrace/'
  md5 '1c65846471db8f10902b96b7b3120da5'

  depends_on 'potrace'
  depends_on 't1utils'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
