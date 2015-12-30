class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v6.0.tar.gz"
  sha256 "d72addb15809bc6229a08ac57e2b87b34eac80346384560ba1f16dae03fbebd5"

  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any
    sha256 "5e379a59a7d17621e2dd8c1cda625a2fad2ea805c02f6d82d6f93e8b5d84da91" => :yosemite
    sha256 "c64243dc2b2779c4f469b81da9a55e9d22361b44d5eee2c426afe009acf2cbc8" => :mavericks
    sha256 "d77022b5c08217dce3f2dce67a47b2b18fe27c7cc3f8a866fbb2d3a0f1cb8291" => :mountain_lion
  end

  def install
    system "make", "all"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
