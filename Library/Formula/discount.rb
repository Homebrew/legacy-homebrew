require 'formula'

class Discount <Formula
  url 'http://github.com/Orc/discount/tarball/v1.6.4'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 '0eef27192e92d586cd1428f501fc6d5a'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}", "--enable-dl-tag", "--enable-pandoc-header", "--enable-superscript", "--relaxed-emphasis", "--enable-div", "--enable-alpha-list"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
