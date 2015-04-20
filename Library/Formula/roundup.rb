require 'formula'

class Roundup < Formula
  homepage 'http://bmizerany.github.io/roundup'
  url 'https://github.com/bmizerany/roundup/archive/v0.0.5.tar.gz'
  sha1 '76ad889ed8e4c32d24847ba2848a8515199e0966'

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

  test do
    system "#{bin}/roundup", "-v"
  end
end
