require "formula"

class Fswatch < Formula
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.0/fswatch-1.4.0.zip"
  sha1 "12031348b0afcc12105c63271aa57e599fc9ab94"

  bottle do
    sha1 "a86d9f5e6e2c5989a204956f6a1329be597d1255" => :mavericks
    sha1 "a969777e2fb984d07c4a9d6ddc99b30072885426" => :mountain_lion
    sha1 "2016e763b3e217e8dc808485309e68f13c20722d" => :lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
