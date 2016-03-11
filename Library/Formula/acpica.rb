class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20160212.tar.gz"
  sha256 "ad26e0632d9800f9df76415f735bb8d4c0901d0596a00e6260f9297281742942"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c31a7094ac5c67c2f71bea114b69cf008a1d00e9a13c710fe3ac180cd8933da" => :el_capitan
    sha256 "16bcd9b2cfdec53612cb03ba20d3a1fea12e48d90c3678b2df73f1ca42295b48" => :yosemite
    sha256 "0ad8f8040c309078985005795a91959d5b6fe522de8727799b5a390ca6754fff" => :mavericks
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
