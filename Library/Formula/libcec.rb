require 'formula'

class Libcec < Formula
  homepage 'http://libcec.pulse-eight.com/'
  url 'https://github.com/Pulse-Eight/libcec/archive/libcec-2.1.1.tar.gz'
  sha1 '81597f9cd0923371bdfb5045ca9d88897152fb3f'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/cec-client", "--info"
  end
end
