class Ponyc < Formula
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.5.tar.bz2"
  sha256 "5347b47106e50a451f962fae0063abb3fdd06d0c3235430d9543d48dc718e6cb"

  bottle do
    sha256 "45de772f0cb381d10f507cfa89ab9744f6fffcf3accd6c067a1406e5128d5ecf" => :yosemite
    sha256 "1bdccb1cf274cbf8a26efc68c34730a8d45525d5ccbae6771e2d2874199083cb" => :mavericks
    sha256 "43803911eaf9e1a82a80af581445b65faa56826490602aff4a12cb1b44c51942" => :mountain_lion
  end

  depends_on "llvm" => ["with-rtti", "without-shared"]
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "destdir=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/builtin"
  end
end
