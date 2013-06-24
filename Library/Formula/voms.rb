require 'formula'

class Voms < Formula
  homepage 'https://github.com/italiangrid/voms'
  url 'https://github.com/italiangrid/voms/archive/2_0_8.tar.gz'
  sha1 'f8c442318636a29da9e2cf8933fa46249b337a05'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    system "sh autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
  end
end
