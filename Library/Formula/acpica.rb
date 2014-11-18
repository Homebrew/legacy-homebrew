require "formula"

class Acpica < Formula
  homepage "https://www.acpica.org/"
  head "https://github.com/acpica/acpica.git"
  url "https://acpica.org/sites/acpica/files/acpica-unix2-20141107.tar.gz"
  sha1 "49e4cbfa39d84f8832cf82455112c868990ef340"

  bottle do
    cellar :any
    sha1 "751442a403e1b2110fd776f23ec24f78da235b97" => :yosemite
    sha1 "647e732c34b8118197dff74efc2307b4f78da89d" => :mavericks
    sha1 "b4c558d517c81251239025b1414a913d690ea8f2" => :mountain_lion
  end

  def install
    ENV.deparallelize
    system "make", "HOST=_APPLE", "PREFIX=#{prefix}"
    system "make", "install", "HOST=_APPLE", "PREFIX=#{prefix}"
  end
end
