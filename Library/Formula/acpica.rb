class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  head "https://github.com/acpica/acpica.git"
  url "https://acpica.org/sites/acpica/files/acpica-unix2-20150619.tar_1.gz"
  sha1 "8c5514b1171afb40dca40289581c8ba3f17583e1"

  bottle do
    cellar :any
    sha1 "283c594c4b89db8e3bef8fca25021c52938987ad" => :yosemite
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
