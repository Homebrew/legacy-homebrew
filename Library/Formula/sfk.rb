class Sfk < Formula
  desc "Command Line Tools Collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.7.6/sfk-1.7.6.tar.gz"
  sha256 "14a5a28903b73d466bfc4c160ca2624df4edb064ea624a94651203247d1f6794"

  bottle do
    cellar :any
    sha256 "42ced5ac947ad0c40cc4f24ef19415ed349929687b89a41d1f558ccfe7d0f434" => :yosemite
    sha256 "ad2b87b8118e5c9c5dc6b41207430c29c9a55ca8058e1b8c4210045849398e8e" => :mavericks
    sha256 "40b99819db133c2b283375d9cd5a6854b962085e69def10e936fc0dff8cd2826" => :mountain_lion
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
