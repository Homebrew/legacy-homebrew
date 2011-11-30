require 'formula'

class Star < Formula
  url 'ftp://ftp.berlios.de/pub/star/star-1.5.1.tar.bz2'
  homepage 'http://cdrecord.berlios.de/old/private/star.html'
  md5 'f9a28f83702624c4c08ef1a343014c7a'

  depends_on "smake" => :build

  def install
    system "smake", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "MANDIR=share/man"
    system "smake", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "MANDIR=share/man", "install"

    # Remove symlinks that override built-in utilities
    Dir.chdir bin do
      Pathname.glob(%w[gnutar tar]) {|p| p.unlink}
    end
  end
end
