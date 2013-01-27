require 'formula'

class Libcec < Formula
  homepage 'http://libcec.pulse-eight.com/'
  url 'https://github.com/Pulse-Eight/libcec/archive/libcec-2.0.5-repack.zip'
  sha1 '94b2c94439156c13499620777bfe03900016879a'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
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
