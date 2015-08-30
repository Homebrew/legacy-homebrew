class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.5.1/fswatch-1.5.1.tar.gz"
  sha256 "29ffbe88878b92c330a032e1d63b8e569a4f7df880494fb2e9c0d3b768541697"

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
