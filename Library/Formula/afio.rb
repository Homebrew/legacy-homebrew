require 'formula'

class Afio < Formula
  homepage 'http://members.chello.nl/~k.holtman/afio.html'
  url 'http://members.chello.nl/~k.holtman/afio-2.5.1.tgz'
  sha1 'bff6b9a147dc5b0e6bd7f1a76f0b84e4dd9a7dc9'

  bottle do
    cellar :any
    sha1 "1a3bbc0e6d6ff0926a75141af4204a6f167af533" => :mavericks
    sha1 "ffda2ae983cf6e1212aff8f4933799f124ec136f" => :mountain_lion
    sha1 "68ecadc2fc7e8dd268ac9e6a63fc12927d60f897" => :lion
  end

  #Note - The Freecode website is being no longer being updated and alternative links should be found from now on.

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
