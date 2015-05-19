class Pigz < Formula
  desc "Parallel gzip"
  homepage "http://www.zlib.net/pigz/"
  url "http://www.zlib.net/pigz/pigz-2.3.3.tar.gz"
  sha1 "11252d38fe2a7b8d7a712dff22bbb7630287d00b"

  bottle do
    cellar :any
    sha1 "90c40dbdaa9c9722496ef7e2f73da037d8996db1" => :yosemite
    sha1 "5a641215041ea36eb15942ceb4dfcae1cd41a0a4" => :mavericks
    sha1 "e4a79a31ddc5a540b7fbb74bb64837522c932ee9" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    man1.install_symlink "pigz.1" => "unpigz.1"
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"pigz", testpath/"example"
    assert (testpath/"example.gz").file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
  end
end
