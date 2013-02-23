require 'formula'

class Voms < Formula
  homepage 'https://github.com/italiangrid/voms'
  url 'https://github.com/italiangrid/voms/tarball/2_0_8'
  sha1 '5dcdbea034152b02646a4aecaafb6888a71b22ed'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    system "sh autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
  end
end
