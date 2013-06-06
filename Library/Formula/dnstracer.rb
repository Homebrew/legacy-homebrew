require 'formula'

class Dnstracer < Formula
  homepage 'http://www.mavetju.org/unix/dnstracer.php'
  url 'http://www.mavetju.org/download/dnstracer-1.9.tar.gz'
  sha1 'b8c60b281c0eb309acd1b1551c51cccb951685c7'

  def install
    ENV.append 'LDFLAGS', '-lresolv'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
