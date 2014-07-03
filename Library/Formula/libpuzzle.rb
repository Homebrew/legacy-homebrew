require 'formula'

class Libpuzzle < Formula
  homepage 'http://libpuzzle.pureftpd.org/project/libpuzzle'
  url 'http://download.pureftpd.org/pub/pure-ftpd/misc/libpuzzle/releases/libpuzzle-0.11.tar.bz2'
  sha1 'a3352c67fd61eab33d5a03c214805b18723d719e'

  bottle do
    cellar :any
    sha1 "58eaf72cba24d8fa442dd881a78447ecf9d266ef" => :mavericks
    sha1 "23522a897cecc2a5da709100b46c8943d773149e" => :mountain_lion
    sha1 "646e0c749303931af5741d22dd9de81655ab23ae" => :lion
  end

  depends_on 'gd'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
