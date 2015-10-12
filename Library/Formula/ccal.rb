class Ccal < Formula
  desc "Create Chinese calendars for print or browsing"
  homepage "http://ccal.chinesebay.com/ccal"
  url "http://ccal.chinesebay.com/ccal/ccal-2.5.3.tar.gz"
  sha256 "3d4cbdc9f905ce02ab484041fbbf7f0b7a319ae6a350c6c16d636e1a5a50df96"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a09b1b16f9b1ea0c89a807ebd2b9cfe43e22d1e35cd576780b1a3c986b4b0d1" => :el_capitan
    sha256 "d3dc167fb2ac1507616dbf5ce5310fd5c67153d680ff242da23a44f199da7fb3" => :yosemite
    sha256 "f79240c70ea10dd661005105e552d8dcc993acfb31c399b3f74f4abf9d2c0162" => :mavericks
  end

  def install
    system "make", "-e", "BINDIR=#{bin}", "install"
    system "make", "-e", "MANDIR=#{man}", "install-man"
  end

  test do
    assert_match "Year JiaWu, Month 1X", shell_output("#{bin}/ccal 2 2014")
  end
end
