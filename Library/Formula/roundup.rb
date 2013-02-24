require 'formula'

class Roundup < Formula
  homepage 'http://bmizerany.github.com/roundup'
  url 'https://github.com/bmizerany/roundup/tarball/v0.0.5'
  sha1 '9a68d8ccc6f3f609344781931561a574c581c7c0'

  head 'https://github.com/bmizerany/roundup.git'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          "--datarootdir=#{share}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/roundup", "-v"
  end
end
