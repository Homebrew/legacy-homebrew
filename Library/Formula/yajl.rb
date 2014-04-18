require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.io/yajl/'
  url 'https://github.com/lloyd/yajl/archive/2.0.4.tar.gz'
  sha256 '0e78f516dc53ecce7dc073f9a9bb0343186b58ef29dcd1dad74e5e853b216dd5'

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
