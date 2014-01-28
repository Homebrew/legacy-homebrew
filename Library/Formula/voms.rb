require 'formula'

class Voms < Formula
  homepage 'https://github.com/italiangrid/voms'
  url 'https://github.com/italiangrid/voms/archive/2_0_11.tar.gz'
  sha1 'dabc2ebe01d01052f5b3849cb04f4947a38d99dd'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    system "sh autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
  end
end
