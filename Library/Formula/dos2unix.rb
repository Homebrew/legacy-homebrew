require 'formula'

class Dos2unix < Formula
  url 'http://sourceforge.net/projects/dos2unix/files/dos2unix/3.2/dos2unix-3.2.tar.gz'
  md5 'db3902feba8a4bae26e9a1bd27c7ce53'
  homepage 'http://dos2unix.sourceforge.net/'

  def install
    # we don't use the Makefile as it doesn't optimize
    system "#{ENV.cc} #{ENV.cflags} dos2unix.c -o dos2unix"

    bin.install %w[dos2unix]
    ln_sf bin+'dos2unix', bin+'mac2unix'
    man1.install %w[mac2unix.1 dos2unix.1]
  end
end
