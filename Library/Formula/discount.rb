require 'formula'

class Discount <Formula
  url 'http://github.com/Orc/discount/tarball/v1.6.7'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 '4c137980f5d8284d67888dede6cefda4'

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
