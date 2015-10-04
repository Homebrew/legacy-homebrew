class Snzip < Formula
  desc "Compression/decompression tool based on snappy"
  homepage "https://github.com/kubo/snzip"
  url "https://bintray.com/artifact/download/kubo/generic/snzip-1.0.2.tar.gz"
  sha256 "b4e4175b9ee74da6c7ee4681d7c8c1b92d7c4aaa4eb79559a2300ab9b2e8eb1b"

  bottle do
    cellar :any
    sha1 "6863e5d8a045551cc2b9aa2e66926a594a1cd2d6" => :yosemite
    sha1 "66d09b8b0fbbf772a61abfa64ab9e2e304a52532" => :mavericks
    sha1 "a5718543e78e7654a3ad8273c2af94b8c8a4855d" => :mountain_lion
  end

  depends_on "snappy"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.out").write "test"
    system "#{bin}/snzip", "test.out"
    system "#{bin}/snzip", "-d", "test.out.sz"
  end
end
