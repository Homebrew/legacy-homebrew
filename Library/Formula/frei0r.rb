require 'formula'

class Frei0r < Formula
  homepage 'http://www.piksel.org/frei0r'
  url 'http://www.piksel.no/frei0r/releases/frei0r-plugins-1.3.tar.gz'
  version '1.3'
  sha1 'f6b463440017934d01ac3c8fdf70b93c915e3d08'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end
end
