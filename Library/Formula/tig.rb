require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  url 'http://jonas.nitro.dk/tig/releases/tig-1.0.tar.gz'
  md5 'a2d414d1cebbc9cd4f3d545bc6f225c6'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
    system "make install-doc-man"

    doc.install Dir['*.html']
    (prefix+'etc/bash_completion.d').install 'contrib/tig-completion.bash'
  end
end
