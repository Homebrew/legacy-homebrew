class Globe < Formula
  desc "Prints ASCII graphic of currently-lit side of the Earth"
  homepage "http://www.acme.com/software/globe/"
  url "http://www.acme.com/software/globe/globe_14Aug2014.tar.gz"
  version "0.0.20140814"
  sha256 "5507a4caaf3e3318fd895ab1f8edfa5887c9f64547cad70cff3249350caa6c86"

  bottle do
    cellar :any
    sha256 "a3ccdf74813e704ab1c8d50bb32f3f9b3f62110c8a6a143e3df85eb6ab7ecd7d" => :yosemite
    sha256 "8ff4dd96c5ab3c846ac61ff66c866e3d4969560611405db6e20436ff75494715" => :mavericks
    sha256 "c37aa4067f2d9ce7b5fbed7246e67164d04e500bfbc193a4a1e19fdba741be85" => :mountain_lion
  end

  def install
    bin.mkpath
    man1.mkpath

    system "make", "all", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    system "#{bin}/globe"
  end
end
