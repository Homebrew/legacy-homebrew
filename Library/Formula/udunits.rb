class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.20.tar.gz"
  sha256 "f10a02014bc6a200d50d8719997bb3a6b3d364de688469d2f7d599688dd9d195"

  bottle do
    revision 1
    sha256 "c003427289ee6b0354219f394b028531f401a80fe385887dc5fdd5f4d3c7c55a" => :el_capitan
    sha256 "81dd936309a2e580e45f2adc9b36974669e03bb9b975b97f67435ac1aa49ba6f" => :yosemite
    sha256 "05dfd1ad2d4dbca918c4d5980594c1689dcf62063e3c06da0c7175599fad4976" => :mavericks
  end

  option "with-html-docs", "Installs html documentation"
  option "with-pdf-docs", "Installs pdf documentation"

  deprecated_option "html-docs" => "with-html-docs"
  deprecated_option "pdf-docs" => "with-pdf-docs"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    args = %w[install]
    args << "install-html" if build.with? "html-docs"
    args << "install-pdf" if build.with? "pdf-docs"
    system "make", *args
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
