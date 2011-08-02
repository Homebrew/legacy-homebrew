require 'formula'

class Botan < Formula
  url 'http://files.randombit.net/botan/v1.10/Botan-1.10.1.tbz'
  homepage 'http://botan.randombit.net/'
  md5 '7ae93e205491a8e75115bfca983ff7f9'

  def install
    system "./configure.py", "--prefix=#{prefix}"
    system "make install"
  end
end
