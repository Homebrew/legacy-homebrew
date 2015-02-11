require 'formula'

class Discount < Formula
  homepage 'http://www.pell.portland.or.us/~orc/Code/discount/'
  url 'http://www.pell.portland.or.us/~orc/Code/discount/discount-2.1.7.tar.bz2'
  sha1 '517bcf7409d8c02b3e57f51264b2e110f8a03120'

  option "with-fenced-code", "Enable Pandoc-style fenced code blocks."

  conflicts_with 'markdown',
    :because => 'both discount and markdown ship a `markdown` executable.'

  def install
    args = %W[
        --prefix=#{prefix}
        --mandir=#{man}
        --with-dl=Both
        --enable-all-features
    ]
    args << "--with-fenced-code" if build.with? "fenced-code"
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make install.everything"
  end
end
