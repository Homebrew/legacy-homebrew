class PdflibLite < Formula
  desc "Subset of the functionality of PDFlib 7"
  homepage "https://www.pdflib.com/download/free-software/pdflib-lite-7/"
  url "https://www.pdflib.com/binaries/PDFlib/705/PDFlib-Lite-7.0.5p3.tar.gz"
  version "7.0.5p3"
  sha256 "e5fb30678165d28b2bf066f78d5f5787e73a2a28d4902b63e3e07ce1678616c9"

  bottle do
    cellar :any
    revision 1
    sha256 "21bf908f2da229ffce18c4a62a3d950de735983cf49893bb6bba13e5e3dff1ae" => :el_capitan
    sha256 "472295629b4a72c5d798ab9a80de9a07425b67a3c4edd00fd0fbcdd92369a640" => :yosemite
    sha256 "29c4882c3931f2e5cff9ed8591dd21ca17371261973aacd8452797873ea2618b" => :mavericks
  end

  def install
    # Without the following substitution, pdflib-lite runs into weird
    # build errors due to bad interactions with the TIFF headers.
    # This workaround comes from the MacPorts.org portfile for pdflib.
    ENV["CPPFLAGS"] = "-isystem#{prefix}"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-java",
                          "--without-perl",
                          "--without-py",
                          "--without-tcl",
                          "--without-ruby"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    pdflib-lite is not open source software; usage restrictions apply!
    Be sure to understand and obey the license terms, which can be found at:
    https://www.pdflib.com/download/free-software/pdflib-lite-7/pdflib-lite-licensing/
    EOS
  end
end
