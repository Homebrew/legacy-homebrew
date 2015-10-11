class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "http://constexpr.org/innoextract/"
  url "http://constexpr.org/innoextract/files/innoextract-1.5.tar.gz"
  sha256 "f2594e992ccf2859455475794803b29a67393fadb69d4df1eec34c451ffa48cf"
  head "https://github.com/dscharrer/innoextract.git"

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
