require 'formula'

class Tig < Formula
  url 'http://jonas.nitro.dk/tig/releases/tig-0.18.tar.gz'
  homepage 'http://jonas.nitro.dk/tig/'
  md5 '4fa9e33c5daa76b6fed11e068405356f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    system "make install-doc-man"

    bash_completion_d = prefix + 'etc' + 'bash_completion.d'
    bash_completion_d.install 'contrib/tig-completion.bash'
  end
end
