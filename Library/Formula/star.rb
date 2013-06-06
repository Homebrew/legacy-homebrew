require 'formula'

class Star < Formula
  homepage 'http://cdrecord.berlios.de/old/private/star.html'
  url 'ftp://ftp.berlios.de/pub/star/star-1.5.1.tar.bz2'
  sha1 '62ba0e0a995fc5deb492b025ecffe58735574b8a'

  depends_on "smake" => :build

  def install
    system "smake", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "MANDIR=share/man"
    system "smake", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "MANDIR=share/man", "install"

    # Remove symlinks that override built-in utilities
    (bin+'gnutar').unlink
    (bin+'tar').unlink
    (man1+'gnutar.1').unlink

    # Remove generic smake files that clash with smake's versions
    (include/'schily').rmtree
    %w[libschily.a libdeflt.a libfind.a].each do |file|
      (lib/file).unlink
    end
    (lib/'profiled').rmtree
  end
end
