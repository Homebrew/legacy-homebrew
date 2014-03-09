require 'formula'

class Isync < Formula
  homepage 'http://isync.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/isync/isync/1.1.0/isync-1.1.0.tar.gz'
  sha1 'd99bd9603e17f94ebe4af1691482a6676ea0fb42'

  head do
    url 'git://git.code.sf.net/p/isync/isync'

    depends_on :autoconf
    depends_on :automake
  end

  depends_on 'berkeley-db'

  def install
    system "touch", "ChangeLog" if build.head?
    system "./autogen.sh" if build.head?

    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
