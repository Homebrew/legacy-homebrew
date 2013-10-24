require 'formula'

class Isync < Formula
  homepage 'http://isync.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/isync/isync/1.0.6/isync-1.0.6.tar.gz'
  sha1 '5cd7403722584b9677fc6a4185c0b9a00f153453'

  head 'git://isync.git.sourceforge.net/gitroot/isync/isync'

  depends_on 'berkeley-db'

  if build.head?
    depends_on :autoconf
    depends_on :automake
  end

  def patches
    # Add "PassCommand" config:
    # http://sourceforge.net/p/isync/patches/12/
    "http://sourceforge.net/p/isync/patches/_discuss/thread/17e52692/e059/attachment/passcommand.patch"
  end if build.head?

  def install
    system "touch", "ChangeLog" if build.head?
    system "./autogen.sh" if build.head?

    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
