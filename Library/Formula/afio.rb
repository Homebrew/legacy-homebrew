require 'formula'

class Afio < Formula
  homepage 'http://freecode.com/projects/afio/'
  url 'http://members.chello.nl/~k.holtman/afio-2.5.1.tgz'
  sha1 'bff6b9a147dc5b0e6bd7f1a76f0b84e4dd9a7dc9'

  option "bzip2", "Use bzip2(1) instead of gzip(1) for compression/decompression"

  def install
    if build.include? "bzip2"
      inreplace "Makefile", "-DPRG_COMPRESS='\"gzip\"'", "-DPRG_COMPRESS='\"bzip2\"'"
      inreplace "afio.c", "with -o: gzip files", "with -o: bzip2 files"
      inreplace "afio.1", "gzip", "bzip2"
      inreplace "afio.1", "bzip2, bzip2,", "gzip, bzip2,"
    end

    system "make", "DESTDIR=#{prefix}"
    bin.install "afio"
    man1.install 'afio.1'

    prefix.install "ANNOUNCE-#{version}" => "ANNOUNCE"
    prefix.install %w(HISTORY INSTALLATION README SCRIPTS)
    share.install Dir["script*"]
  end
end
