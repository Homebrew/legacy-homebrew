require 'formula'

class Flac2Mp3 < Formula
  url 'https://github.com/rmndk/flac2mp3/tarball/v1.0'
  sha1 '07d83e9264e7159a3df50d8422fb1db07f827f55'
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
