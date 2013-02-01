require 'formula'

class Pdsh < Formula
  homepage 'https://computing.llnl.gov/linux/pdsh.html'
  url 'http://pdsh.googlecode.com/files/pdsh-2.28.tar.bz2'
  sha1 'd83612e357b00566623e668fb24e93836de89fec'

  option "without-dshgroups", "Compile without dshgroups which conflicts with genders. The option should be specified to load genders module first instead of dshgroups."

  depends_on 'readline'
  depends_on 'genders' => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--with-ssh",
            "--without-rsh",
            "--with-nodeupdown",
            "--with-readline",
            "--without-xcpu"]

    args << '--with-genders' if build.with? 'genders'
    args << ((build.include? 'without-dshgroups') ? '--without-dshgroups' : '--with-dshgroups')

    system "./configure", *args
    system "make install"
  end
end
