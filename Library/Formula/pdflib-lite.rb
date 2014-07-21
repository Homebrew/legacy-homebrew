require 'formula'

class PdflibLite < Formula
  homepage 'http://www.pdflib.com/download/free-software/pdflib-lite/'
  url 'http://www.pdflib.com/binaries/PDFlib/705/PDFlib-Lite-7.0.5p3.tar.gz'
  version '7.0.5p3'
  sha1 '42e0605ae21f4b6d25fa2d20e78fed6df36fbaa9'

  bottle do
    cellar :any
    sha1 "3a6acc7ff25b9738f6ba7511d23e5045874eafe0" => :mavericks
    sha1 "503d37a1c3299f73125368aa46c186ac332a6074" => :mountain_lion
    sha1 "2c56052904434bcec59986dba82cacf9b9be9adb" => :lion
  end

  def install
    # Without the following substitution, pdflib-lite runs into weird
    # build errors due to bad interactions with the TIFF headers.
    # This workaround comes from the MacPorts.org portfile for pdflib.
    ENV['CPPFLAGS'] = "-isystem#{prefix}"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-java",
                          "--without-perl",
                          "--without-py",
                          "--without-tcl",
                          "--without-ruby"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    pdflib-lite is not open source software; usage restrictions apply!
    Be sure to understand and obey the license terms, which can be found at:
    http://www.pdflib.com/download/free-software/pdflib-lite-7/pdflib-lite-licensing/
    EOS
  end
end
