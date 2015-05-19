class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  head "https://github.com/acpica/acpica.git"
  url "https://acpica.org/sites/acpica/files/acpica-unix2-20150204.tar.gz"
  sha1 "8c5514b1171afb40dca40289581c8ba3f17583e1"

  bottle do
    cellar :any
    sha1 "dbb1b43a1702b3eb2855dd4df1ffbb81a4e5e3c1" => :yosemite
    sha1 "5c2ded46bf71f187b637fd748d541985493ddf57" => :mavericks
    sha1 "c546de5f0bd9ead75dc58baba0489e0a37eb0f60" => :mountain_lion
  end

  def install
    ENV.deparallelize
    system "make", "HOST=_APPLE", "PREFIX=#{prefix}"
    system "make", "install", "HOST=_APPLE", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
