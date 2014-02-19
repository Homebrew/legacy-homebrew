require 'formula'

class Duti < Formula
  homepage 'http://duti.org/'
  head 'https://github.com/fitterhappier/duti.git'
  url 'http://downloads.sourceforge.net/project/duti/duti/duti-1.5.1/duti-1.5.1.tar.gz'
  sha1 '4964cef4196daf4efd3970b09843fc624a21079b'

  depends_on :autoconf

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/duti", "-x", "txt"
  end
end
