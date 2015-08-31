class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.5.1/fswatch-1.5.1.tar.gz"
  sha256 "29ffbe88878b92c330a032e1d63b8e569a4f7df880494fb2e9c0d3b768541697"

  bottle do
    cellar :any
    sha256 "01c6ba63fa749acb260167c555524d6e4cda0b0c93ee5b7d780c7ee734df27d2" => :yosemite
    sha256 "dc821978335a1eca4477dcfc4584924e73447a947e3acb3b1794567290edf6e0" => :mavericks
    sha256 "6d7b1b8c4720f9861d9a91c408b9f355d790f2b5fa65e116612a85e04438f1e7" => :mountain_lion
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
