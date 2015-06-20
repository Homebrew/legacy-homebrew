class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  head "https://github.com/acpica/acpica.git"
  url "https://acpica.org/sites/acpica/files/acpica-unix2-20150619.tar_1.gz"
  sha256 "12d68f781c9f5c3dfb61ef280f41f0d019d7ba4e914ef916ed3e1d22712ffd52"

  bottle do
    cellar :any
    sha1 "dbb1b43a1702b3eb2855dd4df1ffbb81a4e5e3c1" => :yosemite
    sha1 "5c2ded46bf71f187b637fd748d541985493ddf57" => :mavericks
    sha1 "c546de5f0bd9ead75dc58baba0489e0a37eb0f60" => :mountain_lion
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
