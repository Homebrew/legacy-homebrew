require 'formula'

class Isync < Formula
  homepage 'http://isync.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/isync/isync/1.0.5/isync-1.0.5.tar.gz'
  sha1 '9d19cde13b644d6e394f06d292b60503396d0500'

  head 'git://isync.git.sourceforge.net/gitroot/isync/isync'

  depends_on 'berkeley-db'

  if build.head?
    depends_on :autoconf
    depends_on :automake
  end

  def install
    system "touch", "ChangeLog" if build.head?
    system "./autogen.sh" if build.head?

    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
