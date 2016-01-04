class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3370.tar.gz"
  mirror "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3370.tar.gz"
  version "3.370"
  sha256 "092897c6dae4dfe42d91d35a738e45e8236aa3d8f9b3ffc7f0e6545b8319c63a"

  bottle do
    cellar :any
    revision 1
    sha256 "b2547586bac20323985eddf44b08f9b3f33272dbb6517d8fd2c467369a67891b" => :el_capitan
    sha256 "1d8292ec9b2e94aa664e1d50a40d53fd11af1143de9f94a2d483619923c61df4" => :yosemite
    sha256 "5f10522a362eddf2ca8a0d8492630076143bc0d8501b5140fd6c82ebcda6799d" => :mavericks
  end

  option "with-examples", "Compile and install example programs"

  resource "examples" do
    url "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip"
    version "2014.01.23"
    sha256 "85b2deecbd40dc2d4311124758784b1ff11db1dd93ac8e7a29f3d6cda5f8aa3d"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
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
