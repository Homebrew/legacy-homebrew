require 'formula'

class Tivodecode < Formula
  url 'http://downloads.sourceforge.net/projects/tivodecode/files/tivodecode/0.2pre4/tivodecode-0.2pre4.tar.gz'
  homepage 'http://tivodecode.sourceforge.net/'
  md5 'cf82385db3e0d708ebdbe5055b8ae7ee'
  version '0.2pre4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
