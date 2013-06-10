require 'formula'

class Flac2Mp3 < Formula
  url 'https://github.com/rmndk/flac2mp3/archive/v1.0.tar.gz'
  sha1 '1fe176c715a6cd780179126d6aa95cf1f15e7ad8'
end

class Flac < Formula
  homepage 'http://xiph.org/flac/'
  url 'http://downloads.xiph.org/releases/flac/flac-1.3.0.tar.xz'
  sha1 'a136e5748f8fb1e6c524c75000a765fc63bb7b1b'

  option :universal

  depends_on 'xz' => :build
  depends_on 'lame'
  depends_on 'libogg' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    # sadly the asm optimisations won't compile since Leopard
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--disable-asm-optimizations",
                          "--enable-sse",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV['OBJ_FORMAT']='macho'

    # adds universal flags to the generated libtool script
    inreplace "libtool" do |s|
      s.gsub! ":$verstring\"", ":$verstring -arch i386 -arch x86_64\""
    end

    system "make install"

    Flac2Mp3.new.brew {|f| bin.install 'flac2mp3'}
  end
end
