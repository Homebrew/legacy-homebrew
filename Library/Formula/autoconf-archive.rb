require 'formula'

class AutoconfArchive < Formula
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2012.11.14.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2012.11.14.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  sha1 'b2bcc46fb9b5ad3da0a3cb4014ed2e0d2b52acec'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
