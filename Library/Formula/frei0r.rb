require 'formula'

class Frei0r < Formula
  homepage 'http://frei0r.dyne.org'
  url 'https://files.dyne.org/frei0r/releases/frei0r-plugins-1.4.tar.gz'
  sha1 'f6b463440017934d01ac3c8fdf70b93c915e3d08'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
