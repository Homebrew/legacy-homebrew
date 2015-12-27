class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.20.tar.gz"
  sha256 "f10a02014bc6a200d50d8719997bb3a6b3d364de688469d2f7d599688dd9d195"

  bottle do
    sha256 "96a8404c5310ef1ef997b008cd19986ccb0d80c02ede040ee1c3bff1e0455852" => :el_capitan
    sha256 "0ad20f0938aec3bf1ded8db9e75670ddfde638aa48c19f63759892e7b20d6a85" => :yosemite
    sha256 "556023a25be4d19680bcbbb3bad8fb4cdd29204956187f34c01aa0fd8b9662aa" => :mavericks
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
