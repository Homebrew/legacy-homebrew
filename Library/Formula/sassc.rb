require 'formula'

class Sassc < Formula
  homepage 'https://github.com/hcatlin/sassc'
  url 'https://github.com/hcatlin/sassc/archive/v1.0.1.tar.gz'

  depends_on :autoconf
  depends_on :libsass

  def install
    system "autoreconf -i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
