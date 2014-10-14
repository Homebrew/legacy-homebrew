require 'formula'

class Star < Formula
  homepage 'http://cdrecord.org/private/star.html'
  url 'https://downloads.sourceforge.net/project/s-tar/star-1.5.3.tar.bz2'
  sha1 '9f94130c6cfab48a2b37fcd5a9ab21bb5c9b52a2'

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
