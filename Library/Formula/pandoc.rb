require "formula"
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/pandoc/"
  url "http://hackage.haskell.org/package/pandoc-1.12.4.2/pandoc-1.12.4.2.tar.gz"
  sha1 "29e035a2707ff5ce534de92cf75a17acf75dea19"

  bottle do
    sha1 "216b78973a1c26c7091839dd7cfa8a50e2cd6fcb" => :mavericks
    sha1 "58d063c1bb5c02dc454de94dde147003998a4e1d" => :mountain_lion
    sha1 "17ebadac09f6c65fe450751e7c1bdae2efdeba2d" => :lion
  end

  resource "completion" do
    url "https://github.com/dsanson/pandoc-completion.git", :branch => "master"
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  patch do
    # The following patch has been committed upstream and is expected
    # to be released with Pandoc 0.13.
    url "https://github.com/jgm/pandoc/commit/fd11a5a5.diff"
    sha1 "1676caa8440982af93e1ccdcfd444371dde81f34"
  end

  def install
    resource("completion").stage do
      bash_completion.install "pandoc-completion.bash"
    end
    cabal_sandbox do
      cabal_install_tools "alex", "happy"
      cabal_install "--only-dependencies", "--constraint=temporary==1.2.0.1"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "pandoc", "-o", "output.html", prefix/"README"
    assert (Pathname.pwd/"output.html").read.include? '<h1 id="synopsis">Synopsis</h1>'
  end
end
