require 'formula'

class Libbson < Formula
  homepage 'https://github.com/mongodb/libbson'
  url 'https://github.com/mongodb/libbson/releases/download/0.8.0/libbson-0.8.0.tar.gz'
  sha1 '1bc746cb80994bf2796ca36f4185a2aeb8de3fb6'

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
