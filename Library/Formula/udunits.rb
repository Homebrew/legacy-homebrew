class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.19.tar.gz"
  sha256 "9449d50a5d408e8e8dce0953b5462071bab96d92d921808c6bce7e33a3524e90"

  bottle do
    sha256 "3aa330fc152eeb7a07ccd6cd7ecb9febbb62e553c23d66ca4ab887be8fc4ee7c" => :el_capitan
    sha256 "87cff3ad47878d9d70c00f3ad1dadb88a452630987a01e531204a3871e096bcd" => :yosemite
    sha256 "b0e9e98d80f806019f4737f836dc0384bfadeabbf40df93816bcf50311f6794c" => :mavericks
    sha256 "47de40fd15a7a8ab34c206d7fe5e8e5c840f6e14102457b0620394f5f44ff18c" => :mountain_lion
  end

  option "with-html-docs", "Installs html documentation"
  option "with-pdf-docs", "Installs pdf documentation"

  deprecated_option "html-docs" => "with-html-docs"
  deprecated_option "pdf-docs" => "with-pdf-docs"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    targets = ["install"]
    targets << "install-html" if build.include? "html-docs"
    targets << "install-pdf" if build.include? "pdf-docs"
    system "make", *targets
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
