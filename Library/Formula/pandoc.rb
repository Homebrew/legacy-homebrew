require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.14.0.4/pandoc-1.14.0.4.tar.gz"
  sha256 "01955bfb1f397ec22bbce10e2df7b4f2214b7289bf79bf51eb7ae0e3b427fadf"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "ea4d6ae77530e0e96bb43b3eec4d543ef21bfc978773309baace41943ec855f6" => :yosemite
    sha256 "afab4a524ad89a4c86b0008a979c6a2e62253f23e5ea02642a4b3f215615fbb9" => :mavericks
    sha256 "1bc7ed1e7aa4394f213d51e1fe34d9aceba2041d9fedc40a743736c02dd3c539" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
      man1.install "man/man1/pandoc.1"
      man5.install "man/man5/pandoc_markdown.5"
    end
    cabal_clean_lib
  end

  test do
    system "pandoc", "-o", testpath/"output.html", prefix/"README"
    assert (testpath/"output.html").read.include? '<h1 id="synopsis">Synopsis</h1>'
  end
end
