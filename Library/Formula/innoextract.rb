class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "http://constexpr.org/innoextract/"
  url "https://github.com/dscharrer/innoextract/archive/1.4.tar.gz"
  sha256 "7f7eabd5e2f138c9739ac0df457b0f81548ed021068b2b1ec640584747887f52"
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
