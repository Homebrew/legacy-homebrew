require 'formula'

class Screenresolution < Formula
  homepage 'https://github.com/shazron/screenresolution'
  url 'https://github.com/shazron/screenresolution/tarball/1.6'
  sha1 '7608ebe53cb1eb0629bec75d948c4199e9ac220f'

  def install
    system "make", "DESTDIR=", "PREFIX=#{prefix}", "install"
  end

  def test
    system "screenresolution"
  end
end
