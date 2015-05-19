class Sfk < Formula
  desc "A Command Line Tools Collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.7.4/sfk-1.7.4.tar.gz"
  sha256 "aeb9c658d8b87c9a11108736dace65bf495a77a51a6a7585442f90b5183d94b3"

  bottle do
    cellar :any
    sha256 "2aae87cc00f346d23426af1003a7d64bd6338ed0ca00baf7c80afcc62b70fdeb" => :yosemite
    sha256 "a902948f223f2df7c4059d017ff073f8e5c9957296f0b2f7ccb667442fb554eb" => :mavericks
    sha256 "d3be90bfa93e1ae8c675f6bacbaa836c52305ee5249af29ae8ad8d787e0bc615" => :mountain_lion
  end

  def install
    # Using the standard ./configure && make install method does not work with sfk as of this version
    # As per the build instructions for OS X, this is all you need to do to build sfk
    system ENV.cxx, "-DMAC_OS_X", "sfk.cpp", "sfkext.cpp", "-o", "sfk"

    # The sfk binary is all you need. There are no man pages or share files
    bin.install "sfk"
  end

  test do
    system "sfk", "ip"
  end
end
