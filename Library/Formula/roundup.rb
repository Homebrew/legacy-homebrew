require 'formula'

class Roundup < Formula
  homepage 'http://bmizerany.github.com/roundup'
  url 'https://github.com/bmizerany/roundup/tarball/v0.0.5'
  md5 '74623a63f4386286caafdec8b9c0f84d'

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
