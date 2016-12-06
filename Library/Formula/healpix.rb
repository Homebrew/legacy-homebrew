require 'formula'

class Healpix < Formula
  homepage 'http://healpix.jpl.nasa.gov/'
  url 'http://downloads.sourceforge.net/project/healpix/Healpix_3.11/Healpix_3.11_2013Apr24.tar.gz'
  sha1 'f7d6a18ca6aad9fe85a66eca36d7a1f0ef783e95'
  version '3.11'

  depends_on 'cfitsio'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def install
    cd "src/C/autotools" do
      system "autoreconf", "--install"
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
      system "make", "install"
    end

    cd "src/cxx/autotools" do
      system "autoreconf", "--install"
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end
