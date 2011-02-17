require 'formula'

class Discount <Formula
  url 'https://github.com/Orc/discount/tarball/v2.0.5'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 'd3e167363a78a35d85f05a9072074c93'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--enable-dl-tag", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
