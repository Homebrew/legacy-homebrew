class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.5.0/fswatch-1.5.0.tar.gz"
  sha256 "153e7d5358e25579964f353d387d814fe6bea57fa1bad7b883b940d402903e59"

  bottle do
    sha256 "a11024232973e598af6791beb0ab8a7679bb4a6c1db522f01328aa21ca68688f" => :yosemite
    sha256 "b11715bcea622723cdad29b79024ab387a05b0334a97394cd44e0d85ea979cca" => :mavericks
    sha256 "fd5cf0501efd4bf87a5069d9af73a6280bfcc004ec77fc003ed619a84448ffe2" => :mountain_lion
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
