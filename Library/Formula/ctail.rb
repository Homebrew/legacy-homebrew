require 'formula'

class Ctail < Formula
  homepage 'https://github.com/pquerna/ctail'
  url 'https://github.com/pquerna/ctail/archive/ctail-0.1.0.tar.gz'
  sha1 'be669c11118c29aac4b76540dfcdf245d29a4a92'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system 'make', 'LIBTOOL=glibtool --tag=CC'
    system 'make install'
  end
end
