class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.5.tar.gz"
  sha256 "f2594e992ccf2859455475794803b29a67393fadb69d4df1eec34c451ffa48cf"
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "b1d25e6844a7975c215a959c96231a3e6acfc6b15c24651aeffe7e4300709037" => :el_capitan
    sha256 "3964f1f383fa4d4576c9e51f09d9956870ac85f02c1affe5ed3ef3ec29009f75" => :yosemite
    sha256 "dcc59554e88d1d9faaed328f772fe7dc5068d597581f4a953c0031421275342d" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
