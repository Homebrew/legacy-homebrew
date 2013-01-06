require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.12.tar.gz'
  mirror 'http://fossies.org/unix/misc/file-5.12.tar.gz'
  sha1 '782db8a2b37ff8ceada9d19c416eaf6c5b8297d4'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make install"

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
