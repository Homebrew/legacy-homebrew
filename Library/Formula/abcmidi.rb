require 'formula'

class Abcmidi < Formula
  homepage 'http://www.ifdo.ca/~seymour/runabc/top.html'
  url 'http://www.ifdo.ca/~seymour/runabc/abcMIDI-2013-11-26.zip'
  version '2013-11-26'
  sha1 '3e743b2a89404ad5a7d7f51c48cc2a32ba50654b'

  def install
    # configure creates a "Makefile" file. A "makefile" file already exist in
    # the tarball. On case-sensitive file-systems, the "makefile" file won't
    # be overridden and will be chosen over the "Makefile" file.
    system "rm", "makefile"

    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    # The Makefile is broken when using --prefix (value is added to path twice).
    # abcmidi author is notified (2012-06-20). In the meantime, here's a fix.
    inreplace "Makefile", "$(DESTDIR)${prefix}", "$(DESTDIR)"

    system "make", "install"
  end

  test do
    system "#{bin}/abc2midi"
  end
end
