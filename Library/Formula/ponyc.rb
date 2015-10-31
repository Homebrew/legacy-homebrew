class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/CausalityLtd/ponyc/archive/0.2.1.tar.gz"
  sha256 "cb8d6830565ab6b47ecef07dc1243029cef962df7ff926140022abb69d1e554e"
  head "https://github.com/CausalityLtd/ponyc.git"

  bottle do
    sha256 "ccee2ae558144cd1bda30376b3fe922e7eb6224ab9e69247deb066f663a4c9ae" => :yosemite
    sha256 "afcef61c4daec2e845e5a99d63fe60c11236d75a1bb9788570ec149dd9eff82c" => :mavericks
    sha256 "b195bbd971219e3a9598e38833589b73b8dd12280a800a91d02bab74e8b1787b" => :mountain_lion
  end

  depends_on "llvm" => "with-rtti"
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "config=release", "destdir=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"
  end
end
