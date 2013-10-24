require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  url 'http://jonas.nitro.dk/tig/releases/tig-1.2.1.tar.gz'
  sha1 '5755bae7342debf94ef33973e0eaff6207e623dc'

  option 'with-docs', 'Build man pages using asciidoc and xmlto'

  if build.with? "docs"
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"

    if build.with? "docs"
      system "make install-doc-man"
    end

    bash_completion.install 'contrib/tig-completion.bash'
  end
end
