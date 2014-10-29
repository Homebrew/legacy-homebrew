require 'formula'

class Wyrd < Formula
  homepage 'http://pessimization.com/software/wyrd/'
  url 'http://pessimization.com/software/wyrd/wyrd-1.4.6.tar.gz'
  sha1 'aaeca29b844825f45aadcf5207f4d1c875e4dc82'

  bottle do
    sha1 "dde6d73145bc484a9f0f62c909c20b26f5029e8d" => :yosemite
    sha1 "92ee61c12e83ece68b9a28d8eb3cb9b95f201dca" => :mavericks
    sha1 "dc2c60f856f3a7b7751a169c4c1ad2e860612af7" => :mountain_lion
  end

  depends_on 'remind'
  depends_on 'objective-caml' => :build
  depends_on 'camlp4' => :build

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8"
    system "make"
    system "make install"
  end
end
