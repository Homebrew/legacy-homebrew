class Clean < Formula
  desc "Search for files matching a regex and delete them"
  homepage "http://clean.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/clean/clean/3.4/clean-3.4.tar.bz2"
  sha256 "761f3a9e1ed50747b6a62a8113fa362a7cc74d359ac6e8e30ba6b30d59115320"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a433c07eb3c8a3846d352ddf27a6ac32fdc6528b6b2e6212f78318ff0f04a6a" => :el_capitan
    sha256 "f06ca56bca5a139222603fac5d84555a1af9812a2dd669e44501b2022a16eef8" => :yosemite
    sha256 "a847561f68c5d636ee3c0802dccfc7a7b1a5cf66030f026b074c000f6cea258d" => :mavericks
  end

  def install
    system "make"
    bin.install "clean"
    man1.install "clean.1"
  end

  test do
    touch testpath/"backup1234"
    touch testpath/"backup1234.testing-rm"

    system bin/"clean", "-f", "-l", "-e", "*.testing-rm"
    assert File.exist?("backup1234")
    assert !File.exist?("backup1234.testing-rm")
  end
end
