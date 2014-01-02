require 'formula'

class Star < Formula
  homepage 'http://cdrecord.berlios.de/old/private/star.html'
  url 'ftp://ftp.berlios.de/pub/star/star-1.5.2.tar.bz2'
  sha1 'be23b7c282dd4f8533be51129d980e03fc5f2365'

  depends_on "smake" => :build

  def install
    ENV.delete 'MAKEFLAGS' # smake does not like -j

    system "smake", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"

    # Remove symlinks that override built-in utilities
    (bin+'gnutar').unlink
    (bin+'tar').unlink
    (man1+'gnutar.1').unlink

    # Remove useless files
    lib.rmtree
    include.rmtree

    # Remove conflicting files
    %w{makefiles makerules}.each { |f| (man5/"#{f}.5").unlink }
  end
end
