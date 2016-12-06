require 'formula'

class Arpwatch < Formula
  url 'ftp://ftp.ee.lbl.gov/arpwatch-2.1a15.tar.gz'
  homepage 'http://http://ee.lbl.gov/'
  md5 'cebfeb99c4a7c2a6cee2564770415fe7'

  # Patch by joncooper to correctly make a directory & fix the /usr/bin/install invocation on OS X
  def patches
    'https://raw.github.com/gist/1058745/b72113730c0bdf0acb2966101937765584d98d08/arpwatch-2.1a15.darwin.patch'
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
