class PdflibLite < Formula
  desc "Subset of the functionality of PDFlib 7"
  homepage "https://www.pdflib.com/download/free-software/pdflib-lite-7/"
  url "https://www.pdflib.com/binaries/PDFlib/705/PDFlib-Lite-7.0.5p3.tar.gz"
  version "7.0.5p3"
  sha256 "e5fb30678165d28b2bf066f78d5f5787e73a2a28d4902b63e3e07ce1678616c9"

  bottle do
    cellar :any
    revision 2
    sha256 "c05f42bfb25d1fa204440a1d421af10f9bf853e94dd17c7325e0382d7683d589" => :el_capitan
    sha256 "e2e8891b33b4f3f2bab8f809e19d9df0450c1e872d39e6d5090094630210ee45" => :yosemite
    sha256 "d4506f8523153b8e452c17f2897d10ce526476ed8e27c913a9325aac2f2b4f0f" => :mavericks
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
