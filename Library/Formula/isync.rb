require 'formula'

class Isync < Formula
  homepage 'http://isync.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/isync/isync/1.0.5/isync-1.0.5.tar.gz'
  sha1 '9d19cde13b644d6e394f06d292b60503396d0500'

  depends_on 'berkeley-db'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
