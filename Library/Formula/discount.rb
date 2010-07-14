require 'formula'

class Discount <Formula
  url 'http://github.com/Orc/discount/tarball/v1.6.6'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 'c05cb804bdf5013aea2e816e5d2233d7'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}", "--enable-dl-tag", "--enable-pandoc-header", "--enable-superscript", "--relaxed-emphasis", "--enable-div", "--enable-alpha-list"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
