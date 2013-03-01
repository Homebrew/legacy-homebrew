require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  url 'http://jonas.nitro.dk/tig/releases/tig-1.1.tar.gz'
  sha1 'de37817e6b53e91b5a8949a5080daf45478bd45f'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
    system "make install-doc-man"

    doc.install Dir['*.html']
    (prefix+'etc/bash_completion.d').install 'contrib/tig-completion.bash'
  end
end
