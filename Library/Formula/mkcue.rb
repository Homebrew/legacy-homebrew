require 'formula'

class Mkcue < Formula
  url 'http://ftp.de.debian.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz'
  homepage 'http://packages.debian.org/source/stable/mkcue'
  md5 'de082e40baf042e23246d54d28cbcdcc'
  version '1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "mkcue"
  end
end
