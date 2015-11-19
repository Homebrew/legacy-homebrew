class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.7.0/fswatch-1.7.0.tar.gz"
  sha256 "3b42c6f2fb42a5abfcbf51170b189f3f45d6181fb8af39860c47c766473c6010"

  bottle do
    cellar :any
    sha256 "5cc8b1b3180bd6ed099afd229807fb3a599056fbf0031d5f7cc007c134cb780b" => :el_capitan
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
