class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "http://releases.ponylang.org/source/ponyc-0.1.7.tar.bz2"
  sha256 "fc6f783f65cd6708a80bdea71f414cada801528143ea22d9bb13957cb7061eb6"
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
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/builtin"
  end
end
