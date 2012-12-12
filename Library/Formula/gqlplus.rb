require 'formula'

class Gqlplus < Formula
  url 'http://downloads.sourceforge.net/project/gqlplus/gqlplus/1.12/gqlplus-1.12.tar.gz'
  homepage 'http://gqlplus.sourceforge.net/'
  sha1 '95bb0085555af94b48bad924d9e7027c9bc3cb93'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    bin.install "gqlplus"
  end
end
