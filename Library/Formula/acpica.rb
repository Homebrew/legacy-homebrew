require "formula"

class Acpica < Formula
  homepage "https://www.acpica.org/"
  head "https://github.com/acpica/acpica.git"
  url "https://acpica.org/sites/acpica/files/acpica-unix2-20140926.tar.gz"
  sha1 "f4a2c8e7afd7441e98b0878c1fff5ffaba2258bd"

  bottle do
    cellar :any
    sha1 "67536b4f83b441486bc629290adf24ae1c068582" => :yosemite
    sha1 "10f7afd73ba977b10db461492344efa40860165d" => :mavericks
    sha1 "19b90793ec68a5c26a1add2cdabd6d6cd83b29de" => :mountain_lion
  end

  def install
    ENV.deparallelize
    system "make", "HOST=_APPLE", "PREFIX=#{prefix}"
    system "make", "install", "HOST=_APPLE", "PREFIX=#{prefix}"
  end
end
