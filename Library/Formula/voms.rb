require 'formula'

class Voms < Formula
  homepage 'https://github.com/italiangrid/voms'
  url 'https://github.com/italiangrid/voms/tarball/2_0_8'
  sha1 '5dcdbea034152b02646a4aecaafb6888a71b22ed'

  def install
    system "sh autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "voms-proxy-init"
  end
end
