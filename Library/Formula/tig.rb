require "formula"

class Tig < Formula
  homepage "http://jonas.nitro.dk/tig/"
  url "http://jonas.nitro.dk/tig/releases/tig-2.0.3.tar.gz"
  sha1 "762dff87ea8691b7c1b5cfdaf077e367c60ef375"

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
