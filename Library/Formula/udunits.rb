require 'formula'

class Udunits < Formula
  url 'ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.1.21.tar.gz'
  homepage 'http://www.unidata.ucar.edu/software/udunits/'
  md5 'daf894f3e4fbf757a459ce83b373424e'

  def options
    [
      ["--html-docs", "Installs html documentation"],
      ["--pdf-docs", "Installs pdf documentation "]
    ]
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    targets = ["install"]
    targets << "install-html" if ARGV.include? "--html-docs"
    targets << "install-pdf" if ARGV.include? "--pdf-docs"
    system "make", *targets
  end
end
