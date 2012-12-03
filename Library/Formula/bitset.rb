require 'formula'

class Bitset < Formula
  homepage 'https://github.com/chriso/bitset'
  url 'https://github.com/downloads/chriso/bitset/bitset-2.8.1.tar.gz'
  sha1 '71c76f8f414421ce7fae61afb9701957178a32aa'

  depends_on 'jemalloc'

  def install
    system "./configure", "--with-jemalloc", "--prefix=#{prefix}"

    system "make install"
  end
end
