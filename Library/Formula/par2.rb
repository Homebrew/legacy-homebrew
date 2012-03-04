require 'formula'

class Par2 < Formula
  homepage 'http://parchive.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/parchive/par2cmdline/0.4/par2cmdline-0.4.tar.gz'
  sha1 '2fcdc932b5d7b4b1c68c4a4ca855ca913d464d2f'

  def patches
    "http://sage.math.washington.edu/home/binegar/src/par2cmdline-0.4-gcc4.patch"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
