class Pigz < Formula
  desc "Parallel gzip"
  homepage "http://www.zlib.net/pigz/"
  url "http://www.zlib.net/pigz/pigz-2.3.3.tar.gz"
  sha256 "4e8b67b432ce7907575a549f3e1cac4709781ba0f6b48afea9f59369846b509c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b69db2b8ee2df836ab5b267cd574929cbd5091be64e31bf5784521ff3b55f1be" => :el_capitan
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
