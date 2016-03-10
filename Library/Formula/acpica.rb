class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20160212.tar.gz"
  sha256 "ad26e0632d9800f9df76415f735bb8d4c0901d0596a00e6260f9297281742942"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51ab4a89dc3e931fbe33961c31f93ec0fa4eb9f4bab03364cebebe58ac6b3694" => :el_capitan
    sha256 "3bf29505e1d269d065737a7152f5d7edd87c6f02a849090c73cbca67cf2c713b" => :yosemite
    sha256 "7e82e6ba4a87489ea74f721505bbb8a8048b9a817457463ab278e4018c1b16c8" => :mavericks
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
