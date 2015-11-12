class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3370.tar.gz"
  mirror "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3370.tar.gz"
  version "3.370"
  sha256 "092897c6dae4dfe42d91d35a738e45e8236aa3d8f9b3ffc7f0e6545b8319c63a"

  bottle do
    cellar :any
    sha256 "57504126a20d43f2ded74383113b7ed899c97f1ff4f55cfc4c7fe53a8d780e26" => :el_capitan
    sha256 "6dc2862f40385939693ce01ccea8f794dc7aeaf85e3d53a79ac40ea6ed430614" => :yosemite
    sha256 "96a8865b7d1f4ad3be76daf085006d2acdbefa8807dfc35156683681d68c6384" => :mavericks
  end

  option "with-examples", "Compile and install example programs"

  resource "examples" do
    url "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip"
    version "2014.01.23"
    sha256 "85b2deecbd40dc2d4311124758784b1ff11db1dd93ac8e7a29f3d6cda5f8aa3d"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "shared"
    system "make", "install"

    if build.with? "examples"
      system "make", "fpack", "funpack"
      bin.install "fpack", "funpack"

      resource("examples").stage do
        # compressed_fits.c does not work (obsolete function call)
        (Dir["*.c"] - ["compress_fits.c"]).each do |f|
          system ENV.cc, f, "-I#{include}", "-L#{lib}", "-lcfitsio", "-lm", "-o", "#{bin}/#{f.sub(".c", "")}"
        end
      end
    end
  end
end
