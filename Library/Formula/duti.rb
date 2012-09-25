require 'formula'

class Duti < Formula
  homepage 'http://duti.org/'
  url 'https://github.com/fitterhappier/duti/tarball/duti-1.5.1'
  sha1 '30f1f3274030fe511668c42b5d63115e9ad21751'
  head 'https://github.com/fitterhappier/duti.git'

  depends_on :autoconf

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/duti", "-x", "txt"
  end
end
