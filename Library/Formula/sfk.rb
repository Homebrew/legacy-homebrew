class Sfk < Formula
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.7.4/sfk-1.7.4.tar.gz"
  sha256 "aeb9c658d8b87c9a11108736dace65bf495a77a51a6a7585442f90b5183d94b3"

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
