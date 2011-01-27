require 'formula'

class Flac2Mp3 <GithubGistFormula
  url 'http://gist.github.com/raw/124242/79857936f1d72824be0fb5d2ac845c02322abea0/flac2mp3'
  md5 '8351009b64afedfeb7a9e162ccd8d94c'
end

class Flac <Formula
  homepage 'http://flac.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/flac/flac-1.2.1.tar.gz'
  md5 '153c8b15a54da428d1f0fadc756c22c7'

  depends_on 'lame'
  depends_on 'libogg' => :optional

  def install
    # sadly the asm optimisations won't compile since Leopard, and nobody
    # cares or knows how to fix it
    system "./configure", "--disable-debug",
                          "--disable-asm-optimizations",
                          "--enable-sse",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV['OBJ_FORMAT']='macho'
    system "make install"

    Flac2Mp3.new.brew {|f| bin.install 'flac2mp3'}
  end
end