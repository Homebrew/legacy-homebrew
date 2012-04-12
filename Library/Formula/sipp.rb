require 'formula'

class Sipp < Formula
  url 'http://downloads.sourceforge.net/project/sipp/sipp/3.2/sipp.svn.tar.gz'
  homepage 'http://sipp.sourceforge.net/'
  md5 '2a3a60cb4317dcf8eb5482f6a955e4d0'
  version '3.2'

  def install
    system "make DESTDIR=#{prefix}"
    bin.install "sipp"
  end
end
