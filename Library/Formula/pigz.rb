class Pigz < Formula
  homepage 'http://www.zlib.net/pigz/'
  url 'http://www.zlib.net/pigz/pigz-2.3.1.tar.gz'
  sha1 '2d5c9a70a6afcf1d8986890026d70c96b9346c07'
  revision 1

  bottle do
    cellar :any
    sha1 "6eb3c6cad2d259e6a3230b9ac596a0357c54c170" => :yosemite
    sha1 "f208f507c57ab7f32d34dc9e9d5ab7d131558d33" => :mavericks
    sha1 "4348380310afb99b698813e76a4ba01e4d024a1a" => :mountain_lion
  end

  # avoid directory traversal vulnerability CVE-2015-1191
  # http://www.openwall.com/lists/oss-security/2015/01/12/4
  # https://github.com/madler/pigz/commit/fdad1406b3ec809f4954ff7cdf9e99eb18c2458f
  patch do
    url "https://sources.debian.net/data/main/p/pigz/2.3.1-2/debian/patches/0002-When-decompressing-with-N-or-NT-strip-any-path-from-.patch"
    sha1 "b5f058c00ba3834f16d7842fa4fef73cbbf41aaf"
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
