require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  url 'http://jonas.nitro.dk/tig/releases/tig-1.0.tar.gz'
  sha1 '3fe744f79d244285b6e00b472e35967746910305'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
    system "make install-doc-man"

    doc.install Dir['*.html']
    (prefix+'etc/bash_completion.d').install 'contrib/tig-completion.bash'
  end
end
