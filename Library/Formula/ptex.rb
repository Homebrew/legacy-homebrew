class Ptex < Formula
  desc "Texture mapping system"
  homepage "http://ptex.us"
  url "https://github.com/wdas/ptex/archive/v2.1.10.tar.gz"
  sha256 "0fb978e57f5e287c34b74896e3a9564a202d8806c75a18dd83855ba6d7c02122"

  bottle do
    cellar :any
    sha256 "21982ca144f0dd43ce5a9c19d8f03bbd8732011f54d5617e093dc2b4e3999f6a" => :el_capitan
    sha256 "db0873c11cdcb3aace1facb63a5f97eb988b01e5654d34eb7d2199b139a1cbb4" => :yosemite
    sha256 "8a3488453c61feb9f81b8a1a81d4f6a696349d186709e3331748182135db551a" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "make", "prefix=#{prefix}"
    system "make", "test"
    system "make", "install"
  end
end
