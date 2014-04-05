require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.io/yajl/'
  url 'https://github.com/lloyd/yajl/archive/2.0.4.tar.gz'
  sha256 '0e78f516dc53ecce7dc073f9a9bb0343186b58ef29dcd1dad74e5e853b216dd5'

  bottle do
    cellar :any
    revision 1
    sha1 "a14cd8f249a7ee6cb3a3c521327c8791ee630886" => :mavericks
    sha1 "f0324b8e04f7552969f5278b647da3e3642aa047" => :mountain_lion
    sha1 "6a5223ba480385bf56b896ef24b8c8dec2929746" => :lion
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
