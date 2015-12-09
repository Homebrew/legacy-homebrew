class Pigz < Formula
  desc "Parallel gzip"
  homepage "http://www.zlib.net/pigz/"
  url "http://www.zlib.net/pigz/pigz-2.3.3.tar.gz"
  sha256 "4e8b67b432ce7907575a549f3e1cac4709781ba0f6b48afea9f59369846b509c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b69db2b8ee2df836ab5b267cd574929cbd5091be64e31bf5784521ff3b55f1be" => :el_capitan
    sha256 "96b7a7d146ab92e2761e2caa44b32f4e7e348c777381f974a5a13edc5b1061da" => :yosemite
    sha256 "67f7bc22e154ab5df412ec11e43fe83bb2731d1deca766c8dcb4c38384f5d8c8" => :mavericks
    sha256 "25a46ace5707f92497a6f1117161377ffaf2501a31dac34a7e4832bdda865759" => :mountain_lion
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
