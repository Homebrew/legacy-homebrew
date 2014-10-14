require 'formula'

class Libkate < Formula
  homepage 'http://code.google.com/p/libkate/'
  url 'https://libkate.googlecode.com/files/libkate-0.4.1.tar.gz'
  sha1 '87fd8baaddb7120fb4d20b0a0437e44ea8b6c9d8'
  revision 1

  bottle do
    sha1 "a19680a224110d19d08e67c34902f7dfb36528ea" => :mavericks
    sha1 "4caeaded00d86b8aeaf9ae5d197e19cc0f93ae91" => :mountain_lion
    sha1 "57d712aca93b4ae898ae11ef482ac31a5022d942" => :lion
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
