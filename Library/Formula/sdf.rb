require 'formula'

class Sdf < Formula
  homepage 'http://strategoxt.org/Sdf/WebHome'
  url 'ftp://ftp.strategoxt.org/pub/stratego/StrategoXT/strategoxt-0.17/sdf2-bundle-2.4.tar.gz'
  sha1 'b9be75d56503e7f06fcc9cc543303bae123c0845'

  depends_on 'pkg-config' => :build
  depends_on 'aterm'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Man pages are distributed as 0B files.
    # Delete them so they'll get recreated properly
    rm %w(pgen/src/sdf2table.1 sglr/doc/sglr.1 sglr/doc/sglr-api.3)

    system "make install"
  end
end
