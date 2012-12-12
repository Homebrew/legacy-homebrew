require 'formula'

class CutyCapt < Formula
  url 'http://ftp.de.debian.org/debian/pool/main/c/cutycapt/cutycapt_0.0~svn6.orig.tar.gz'
  homepage 'http://cutycapt.sourceforge.net/'
  sha1 '9c35cff498e8dfc351cbfeb884ad69f6ba29ae2e'
  version '0.0.6'

  depends_on 'qt'

  def install
    system "qmake CONFIG-=app_bundle"
    system "make"
    bin.install "CutyCapt"
  end
end
