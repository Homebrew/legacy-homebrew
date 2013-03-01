require 'formula'

class Mkcue < Formula
  homepage 'http://packages.debian.org/source/stable/mkcue'
  url 'http://ftp.de.debian.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz'
  version '1'
  sha1 'd9a69718ba3d862b589588bdf61796f755200f9d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "mkcue"
  end
end
