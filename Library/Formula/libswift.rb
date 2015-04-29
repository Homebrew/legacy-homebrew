class Libswift < Formula
  homepage "http://libswift.org/"
  url "https://github.com/libswift/libswift/archive/v0.1-beta.tar.gz"
  version "0.1-beta"
  sha256 "ba7869e0a4e1ec4b6b8f526ffc53137d9f39b5da1562b3bac1454a60f4ceb88b"
  head "https://github.com/libswift/libswift.git", :branch => :devel

  depends_on "libevent"

  def install
    system "make"
    bin.install "swift" => "libswift"
  end

  test do
    # make a merkle tree hash from an arbitrary file
    system "#{bin}/libswift", "-f", "#{bin}/libswift"
  end
end
