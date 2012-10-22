require 'formula'

class Pdsh < Formula
  homepage 'https://computing.llnl.gov/linux/pdsh.html'
  url 'http://sourceforge.net/projects/pdsh/files/pdsh/pdsh-2.26/pdsh-2.26.tar.bz2'
  sha1 'bdcec89760b93bd12107d8a785ca2710853cde75'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ssh",
                          "--without-rsh",
                          "--with-dshgroups",
                          "--with-nodeupdown",
                          "--with-readline",
                          "--without-xcpu"
    system "make install"
  end
end
