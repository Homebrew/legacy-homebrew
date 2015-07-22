class Sqlitebrowser < Formula
  desc "Visual tool to create, design, and edit SQLite databases"
  homepage "http://sqlitebrowser.org"
  url "https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.7.0.tar.gz"
  sha256 "3093a1dcf5b3138c1adf29857d62249ab2b068e70b001869a31151763e28cc3a"

  head "https://github.com/sqlitebrowser/sqlitebrowser.git"

  bottle do
    cellar :any
    sha256 "0f94ada07ec575124cac4cb5ebc3e4dfa072150a4f79764153e30187077f0ccd" => :yosemite
    sha256 "7a7abdea93ad0401a29eac53c54066f366619717e07c14b9e2f9a1487a8a54ce" => :mavericks
    sha256 "d675792776191eb65256b6aba1f7a50099a2768eb5c3975e4efa224cb95978ba" => :mountain_lion
  end

  depends_on "qt"
  depends_on "cmake" => :build
  depends_on "sqlite" => "with-functions"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
