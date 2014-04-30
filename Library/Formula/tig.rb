require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'

  stable do
    url "http://jonas.nitro.dk/tig/releases/tig-2.0.1.tar.gz"
    sha1 "db3c740e4fbd198cb9d9c47ddb720739139e69e3"
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
