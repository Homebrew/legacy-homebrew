require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  head 'https://github.com/jonas/tig.git'
  url 'http://jonas.nitro.dk/tig/releases/tig-1.2.1.tar.gz'
  sha1 '5755bae7342debf94ef33973e0eaff6207e623dc'

  option 'with-docs', 'Build man pages using asciidoc and xmlto'

  if build.with? "docs"
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  # fixes the problem with displaying/searching multibyte characters
  # upstream pull request: https://github.com/jonas/tig/issues/99
  def patches
  [
    "https://github.com/spin6lock/tig/commit/159eff692b24aa05f766f76922b0f2515fbbf415.diff",
    "https://github.com/spin6lock/tig/commit/70cb91e7d210b92ab012d9819bd20ebe92885bd6.diff"
  ]
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
    system "make install-doc-man" if build.with? "docs"
    bash_completion.install 'contrib/tig-completion.bash'
  end
end
