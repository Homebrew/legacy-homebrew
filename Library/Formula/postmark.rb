require 'formula'

class Postmark < Formula
  homepage 'http://packages.debian.org/stable/utils/postmark'
  url 'http://mirrors.kernel.org/debian/pool/main/p/postmark/postmark_1.51.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/p/postmark/postmark_1.51.orig.tar.gz'
  sha1 '2cf0be75e3cb255f36fb1f3e412bcf8f81b39969'

  def install
    system "cc -o postmark postmark-*.c"
    bin.install "postmark"
  end
end
