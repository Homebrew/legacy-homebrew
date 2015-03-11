require "formula"

class Tig < Formula
  homepage "http://jonas.nitro.dk/tig/"
  url "http://jonas.nitro.dk/tig/releases/tig-2.1.tar.gz"
  sha1 "2527cfee62a890f25c7c2ae8c1a16e5fa201ce29"

  bottle do
    cellar :any
    sha256 "8efbb377b3edc371349e9eb7c014e1c6cf982ad7f6de8f51f2ff1bfacb514eaa" => :yosemite
    sha256 "d304edaf4eb06511f89a85a8821180caf5d6677a84ab87240a13ad132aabf09a" => :mavericks
    sha256 "4f16770794c63c073e9f517e173284f4015879a0b06660ba5fc66682c9f70fcf" => :mountain_lion
  end

  head do
    url "https://github.com/jonas/tig.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-docs", "Build man pages using asciidoc and xmlto"

  if build.with? "docs"
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
    system "make install-doc-man" if build.with? "docs"
    bash_completion.install "contrib/tig-completion.bash"
  end
end
