require 'formula'

class Dash <Formula
  url 'http://ftp.debian.org/debian/pool/main/d/dash/dash_0.5.5.1.orig.tar.gz'
  homepage 'http://packages.debian.org/sid/dash'
  md5 '7ac832b440b91f5a52cf8eb68e172616'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-libedit"
    system "make"
    system "make install"
  end
end
