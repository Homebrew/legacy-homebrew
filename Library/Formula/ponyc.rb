class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/CausalityLtd/ponyc/archive/0.2.1.tar.gz"
  sha256 "cb8d6830565ab6b47ecef07dc1243029cef962df7ff926140022abb69d1e554e"
  head "https://github.com/CausalityLtd/ponyc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eaf27f863ca4bb8c233b8eb0a150ffca60c86fe57d1c630ba7b105d969eb9c8" => :el_capitan
    sha256 "6d29e002a35b49d9451111f0758f919a3d3f1016ce58db5365eaabce253d8162" => :yosemite
    sha256 "6feb5a4031bcb8a23b0cbfe036d67df3f0ef4424533a66e5f4fdef29dec7d118" => :mavericks
  end

  depends_on "llvm"
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "config=release", "destdir=#{prefix}", "verbose=1"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"
  end
end
