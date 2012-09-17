require 'formula'

class Pdsh < Formula
  homepage 'https://computing.llnl.gov/linux/pdsh.html'
  url 'https://pdsh.googlecode.com/files/pdsh-2.28.tar.bz2'
  sha1 'd83612e357b00566623e668fb24e93836de89fec'

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
