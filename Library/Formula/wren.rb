class Wren < Formula
  homepage "http://munificent.github.io/wren/"
  url "https://github.com/munificent/wren/archive/efd161cea278e5cc9d6b404451443cf48d4057a8.tar.gz"
  sha1 "f8757ad1b3dbe312c2928e00e095007d87b97748"

  depends_on "pkg-config" => :build

  def install
    system "make"
    bin.install "wren"
    prefix.install Dir["*"]
  end

  test do
    prefix.cd do
      system "make", "test"
    end
  end
end
