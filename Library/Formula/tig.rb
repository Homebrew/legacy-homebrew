require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  url 'http://jonas.nitro.dk/tig/releases/tig-0.18.tar.gz'
  md5 '4fa9e33c5daa76b6fed11e068405356f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    system "make install-doc-man"

    doc.install Dir['*.html']
    (prefix+'etc/bash_completion.d').install 'contrib/tig-completion.bash'
  end
end
