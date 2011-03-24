require 'formula'

class CutyCapt < Formula
  url 'http://ftp.de.debian.org/debian/pool/main/c/cutycapt/cutycapt_0.0~svn6.orig.tar.gz'
  homepage 'http://cutycapt.sourceforge.net/'
  md5 '02f57ff05753ee63b922715709a6bd5c'
  version '0.0.6'

  depends_on 'qt'

  def install
    system "qmake CONFIG-=app_bundle"
    system "make"
    bin.install "CutyCapt"
  end
end
