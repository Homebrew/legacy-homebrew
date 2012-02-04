require 'formula'

class Flac2Mp3 < GithubGistFormula
  url 'https://gist.github.com/raw/876936/ad4bf55ce071c708da0d0d06dcc8111787a3138d/flac2mp3'
  md5 '76be2077f0422f22bc9623eecdaee187'
end

class Flac < Formula
  homepage 'http://flac.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/flac/flac-1.2.1.tar.gz'
  md5 '153c8b15a54da428d1f0fadc756c22c7'

  depends_on 'lame'
  depends_on 'libogg' => :optional

  fails_with_llvm "Undefined symbols when linking", :build => 2326

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
