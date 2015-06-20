class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  head "https://github.com/acpica/acpica.git"
  url "https://acpica.org/sites/acpica/files/acpica-unix2-20150619.tar.gz"
  sha256 "7884f414a8f3bc58c21f3e9bc4f0094771fa665be0b24140b54bd7477764f215"

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
