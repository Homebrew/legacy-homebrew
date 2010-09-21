require 'formula'

class Discount <Formula
  url 'http://github.com/Orc/discount/tarball/v1.6.8'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 '45f9784464e973885884ffb01bd3f7e8'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--enable-dl-tag", "--enable-pandoc-header",
                             "--enable-superscript", "--relaxed-emphasis",
                             "--enable-div", "--enable-alpha-list"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
