require 'formula'

class Flac2Mp3 < Formula
  url 'https://raw.github.com/rmndk/flac2mp3/master/flac2mp3'
  sha1 'bd54354900181b59db3089347cc84ad81e410b38'
end

class Flac < Formula
  homepage 'http://flac.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/flac/flac-1.2.1.tar.gz'
  sha1 'bd54354900181b59db3089347cc84ad81e410b38'

  depends_on 'lame'
  depends_on 'libogg' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

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
