require 'formula'

class Libsmi < Formula
  homepage 'http://www.ibr.cs.tu-bs.de/projects/libsmi/'
  url 'https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.4.8.tar.gz'
  sha1 '77c512ccbdd29667d152398b0dcde533aed57b49'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
