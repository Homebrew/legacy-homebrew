require 'formula'

class Openmotif < Formula
  url 'http://www.motifzone.net/files/public_downloads/openmotif/2.3/stable/openmotif-2.3.0.tar.gz'
  homepage 'http://www.motifzone.net'
  md5 '99d0ecb84d3504da421021a19ff70500'

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--mandir=#{man}"

    system "./configure", *args
    ENV.j1
    system "make"
    system "make install"
  end
end
