require 'formula'

class Botan < Formula
  url 'http://botan.randombit.net/files/Botan-1.8.11.tgz'
  homepage 'http://botan.randombit.net/'
  md5 'ccb2c3cb8a324214a89b45a03422870b'

  def install
    system "./configure.py", "--prefix=#{prefix}"
    system "make install"
  end
end
