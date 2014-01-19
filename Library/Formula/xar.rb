require 'formula'

class Xar < Formula
  homepage 'https://github.com/mackyle/xar'
  url 'https://github.com/downloads/mackyle/xar/xar-1.6.1.tar.gz'
  sha1 '6f7827a034877eda673a22af1c42dc32f14edb4c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end


__END__
