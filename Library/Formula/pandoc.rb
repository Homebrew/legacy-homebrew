require "formula"
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/pandoc/"
  url "http://hackage.haskell.org/package/pandoc-1.12.4.2/pandoc-1.12.4.2.tar.gz"
  sha1 "29e035a2707ff5ce534de92cf75a17acf75dea19"
  revision 1

  bottle do
    sha1 "fb93514850f6bb8dfb1c5d0eab8a911dc741fc07" => :mavericks
    sha1 "2db6d096a37d2f06909669a5be38d0b8e3eae035" => :mountain_lion
    sha1 "c1c385ad031503c1540ec515f3a1552e51783569" => :lion
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
