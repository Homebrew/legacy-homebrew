class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.7.tar.bz2"
  sha256 "fc6f783f65cd6708a80bdea71f414cada801528143ea22d9bb13957cb7061eb6"

  bottle do
    sha256 "c5d4837fdcdcb8abff9faef03002b64ea589e53cb10cfcd703eee505483f5fed" => :yosemite
    sha256 "9b96cf934f39d9f61170704ba1165b718b868bd56bc089a343970a9ef0ca8d3d" => :mavericks
    sha256 "49e11ccb179955ad14703e5ce2c965b28519d2937b82b4b93379c8356aac4925" => :mountain_lion
  end

  depends_on "llvm" => "with-rtti"
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "config=release", "destdir=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/builtin"
  end
end
