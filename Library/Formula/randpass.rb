require 'formula'

class Randpass < Formula
  homepage 'http://dogriffiths.github.com/randpass/'
  url 'https://github.com/dogriffiths/randpass/archive/v1.0.9.tar.gz'
  sha1 '207db253aa2f5d8b3e5a30b13929eb1d3cedf013'

  def install
    system "./configure"
    system "make install" # if this fails, try separate make/make install steps
  end

  test do
    system "randpass"
  end
end