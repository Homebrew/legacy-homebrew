require 'formula'

class Normalize < Formula
  url 'https://github.com/kklobe/normalize/tarball/0.7.7.1'
  homepage 'https://github.com/kklobe/normalize'
  md5 '56380e132f8313adb6b3494b5c0f83f6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  def test
    system "make check"
  end
end
