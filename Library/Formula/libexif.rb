require 'formula'

class Libexif < Formula
  homepage 'http://libexif.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/libexif/libexif/0.6.21/libexif-0.6.21.tar.gz'
  sha1 '4106f02eb5f075da4594769b04c87f59e9f3b931'

  bottle do
    cellar :any
    sha1 "4d59cec33b869a8f18b7c2bb8efdf089075f97ee" => :mavericks
    sha1 "41409da6d22a77fd545912058a6ceb41ec2c33cd" => :mountain_lion
    sha1 "19e0943cb26d67b2b974438f5ec4e63e78e0eadd" => :lion
  end

  fails_with :llvm do
    build 2334
    cause "segfault with llvm"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
