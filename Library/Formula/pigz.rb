class Pigz < Formula
  homepage 'http://www.zlib.net/pigz/'
  url 'http://www.zlib.net/pigz/pigz-2.3.1.tar.gz'
  sha1 '2d5c9a70a6afcf1d8986890026d70c96b9346c07'

  bottle do
    cellar :any
    sha1 "3aa3d204457ffda3815b62f3f1530caedfede0f4" => :yosemite
    sha1 "836f8a39e7e524da44cb03a34a5962c690668378" => :mavericks
    sha1 "65c9d79d6610f35008549afab203e9058f937a20" => :mountain_lion
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
