require "formula"

class Cfitsio < Formula
  homepage "http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3370.tar.gz"
  mirror "https://downloads.sourceforge.net/project/machomebrew/mirror/cfitsio-3.370.tar.gz"
  sha1 "dbe3cc6981951d29200f442f4ab318f8899f9cc8"
  version "3.370"

  option "with-examples", "Compile and install example programs"

  resource "examples" do
    url "http://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip"
    version "2014.01.23"
    sha1 "39a66bb611bf611e7c88f0a410234c0d4955529c"
  end if build.with? "examples"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make shared"
    system "make install"

    if build.with? "examples"
      system "make fpack funpack"
      bin.install "fpack", "funpack"

      resource("examples").stage do
        # compressed_fits.c does not work (obsolete function call)
        (Dir["*.c"] - ["compress_fits.c"]).each do |f|
          system ENV.cc, f, "-I#{include}", "-L#{lib}", "-lcfitsio", "-lm", "-o", "#{bin}/#{f.sub('.c', '')}"
        end
      end
    end
  end
end
