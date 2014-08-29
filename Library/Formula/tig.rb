require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'

  stable do
    url "http://jonas.nitro.dk/tig/releases/tig-2.0.2.tar.gz"
    sha1 "de01c3a52952172e42ae642d97a55505d7e09efd"
  end

  head do
    url "https://github.com/jonas/tig.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option 'with-docs', 'Build man pages using asciidoc and xmlto'

  if build.with? "docs"
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
    system "make install-doc-man" if build.with? "docs"
    bash_completion.install 'contrib/tig-completion.bash'
  end
end
