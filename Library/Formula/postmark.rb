require 'formula'

class Postmark <Formula
  url 'http://mirrors.kernel.org/debian/pool/main/p/postmark/postmark_1.51.orig.tar.gz'
  homepage 'http://packages.debian.org/stable/utils/postmark'
  md5 'b494167c2df1850004110ab28e5ad164'

  def install
    system "cc -o postmark postmark-*.c"
    bin.install "postmark"
  end
end
