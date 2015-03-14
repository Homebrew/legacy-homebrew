class Udunits < Formula
  homepage "http://www.unidata.ucar.edu/software/udunits/"
  url "ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.18.tar.gz"
  sha256 "f542ed81140db2dae862a0018c8cddaf3b9ded1886e3755489b9329c7ecf8de0"

  bottle do
    sha256 "ba540f03f0fb0b4de7d8c9e415a75c0365c5d86387eea9b48582bd6951f1649e" => :yosemite
    sha256 "2b050af349aa4d8a697fd891d93432dda6b7f679c8aef7841e9a0294a915ae7e" => :mavericks
    sha256 "d6127ced32f43233385e01325c3793c26a9ae9278143197d9318083037293157" => :mountain_lion
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
