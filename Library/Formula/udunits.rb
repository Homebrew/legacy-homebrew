require 'formula'

class Udunits < Formula
  homepage 'http://www.unidata.ucar.edu/software/udunits/'
  url 'ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.1.24.tar.gz'
  md5 '6986545721747a51285c765644dcd9d8'

  def options
    [
      ["--html-docs", "Installs html documentation"],
      ["--pdf-docs", "Installs pdf documentation"]
    ]
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    targets = ["install"]
    targets << "install-html" if ARGV.include? "--html-docs"
    targets << "install-pdf" if ARGV.include? "--pdf-docs"
    system "make", *targets
  end
end
