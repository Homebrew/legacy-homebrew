require 'formula'

class Pdsh < Formula
  url 'http://downloads.sourceforge.net/project/pdsh/pdsh/pdsh-2.18/pdsh-2.18.tar.bz2'
  homepage 'https://computing.llnl.gov/linux/pdsh.html'
  md5 'ff5dc11f25ce9c7474e71aafb5d293e8'

  depends_on 'readline'

  # don't strip binaries
  skip_clean ['bin', 'lib']

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ssh", "--without-rsh",
                          "--with-dshgroups", "--with-nodeupdown",
                          "--with-readline", "--without-xcpu", "--mandir=#{man}"
    system "make install"
  end
end
