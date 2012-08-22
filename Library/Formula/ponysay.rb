require 'formula'



class Ponysay < Formula
  homepage 'https://github.com/erkin/ponysay'
  url 'https://github.com/erkin/ponysay/tarball/2.2'
  sha1 '4244c7f819055b26f8e0581f1c5c909bf2f6d9cd'

  depends_on 'cowsay'
  depends_on 'coreutils'
  depends_on 'python3'

  def install
    system "./configure", "--prefix=#{prefix}", "--without-info", "--without-shared-cache"
    system "make"
    system "make install"
  end

  def test
    system "ponysay"
  end
end
