class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20151218.tar.gz"
  sha256 "6033e92c2ce3c5fa6a02c7e28bb5b37fb1c2bcac2fb467acd2d9a67e4d727d00"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "cc725e69697566a45bc3398020ed869428096585f1a719c327cca44179bb4ab6" => :el_capitan
    sha256 "97f48c365f61d024a47dc37d074bf12b3946b006e4f047f6b06ab47e98c58dfe" => :yosemite
    sha256 "2dee2a8911b99c8cc52b1534d9f6f0e87c04521d81a1b89c5ac46f7a149cd4db" => :mavericks
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
