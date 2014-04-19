require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.io/yajl/'
  url 'https://github.com/lloyd/yajl/archive/2.1.0.tar.gz'
  sha256 '3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a'

  bottle do
    cellar :any
    revision 2
    sha1 "af68f69413be09a3d2d14cc5386e1e85a9a78bf7" => :mavericks
    sha1 "ff252003191bdda938f9654f354e614814da416c" => :mountain_lion
    sha1 "e5420c37b8facd072bc87ec57eec52f9088a2bb9" => :lion
  end

  # Configure uses cmake internally
  depends_on 'cmake' => :build

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (include/'yajl').install Dir['src/api/*.h']
  end

  test do
    output = `echo "[0,1,2,3]" | '#{bin}/json_verify'`
    assert $?.success?
    assert_match /valid/i, output.strip
  end
end
