require 'formula'

class Udunits < Formula
  homepage 'http://www.unidata.ucar.edu/software/udunits/'
  url 'ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.1.24.tar.gz'
  sha1 '64bbb4b852146fb5d476baf4d37c9d673cfa42f9'

  option "html-docs", "Installs html documentation"
  option "pdf-docs", "Installs pdf documentation"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    targets = ["install"]
    targets << "install-html" if build.include? "html-docs"
    targets << "install-pdf" if build.include? "pdf-docs"
    system "make", *targets
  end
end
