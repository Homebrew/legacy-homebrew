require 'formula'

class Tig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  url 'http://jonas.nitro.dk/tig/releases/tig-1.2.tar.gz'
  sha1 '38bff28a205b94623ad0c087a3073c986002dc83'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
    system "make install-doc-man"

    doc.install Dir['*.html']
    bash_completion.install 'contrib/tig-completion.bash'
  end
end
