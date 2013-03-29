require 'formula'

class Discount < Formula
  homepage 'http://www.pell.portland.or.us/~orc/Code/discount/'
  url 'https://github.com/Orc/discount/archive/v2.1.5a.tar.gz'
  sha1 '83906e1f349eb13ea629f4f6e59a7f392e07a411'

  version 'v2.1.5a'

  conflicts_with 'markdown',
    :because => 'both discount and markdown ship a `markdown` executable.'

  def install
    system "./configure.sh", "--prefix=#{prefix}",
                             "--mandir=#{man}",
                             "--with-dl=Both",
                             "--enable-all-features"
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make install.everything"
  end
end
