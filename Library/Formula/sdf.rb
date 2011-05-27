require 'formula'

class Sdf < Formula
  url 'ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.17/sdf2-bundle-2.4.tar.gz'
  homepage 'http://strategoxt.org/Sdf/WebHome'
  md5 '8aa110d790c4a8bf7bc8b884590d7bee'

  depends_on 'aterm'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Man pages are distributed as 0B files.
    # Delete them so they'll get recreated properly
    rm %w(pgen/src/sdf2table.1 sglr/doc/sglr.1 sglr/doc/sglr-api.3)

    system "make install"
  end
end
