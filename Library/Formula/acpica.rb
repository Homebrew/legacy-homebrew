class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20151218.tar.gz"
  sha256 "6033e92c2ce3c5fa6a02c7e28bb5b37fb1c2bcac2fb467acd2d9a67e4d727d00"
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
