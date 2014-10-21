require 'formula'

class Libkate < Formula
  homepage 'http://code.google.com/p/libkate/'
  url 'https://libkate.googlecode.com/files/libkate-0.4.1.tar.gz'
  sha1 '87fd8baaddb7120fb4d20b0a0437e44ea8b6c9d8'
  revision 1

  bottle do
    revision 1
    sha1 "97d80c510059826dc80316c8c4861cdc6ad8261e" => :yosemite
    sha1 "ce7aa340bba256de2ac0f0018ad577605448e300" => :mavericks
    sha1 "8ed93646139c5ec85a9fb9efdab9fa4f161a62d6" => :mountain_lion
  end

  depends_on 'libpng'
  depends_on 'libogg' => :recommended

  fails_with :gcc do
    build 5666
    cause "Segfault during compilation"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
