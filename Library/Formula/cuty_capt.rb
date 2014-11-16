require 'formula'

class CutyCapt < Formula
  homepage 'http://cutycapt.sourceforge.net/'
  url 'http://ftp.de.debian.org/debian/pool/main/c/cutycapt/cutycapt_0.0~svn6.orig.tar.gz'
  version '0.0.6'
  sha1 '9c35cff498e8dfc351cbfeb884ad69f6ba29ae2e'

  depends_on 'qt'

  def install
    system "qmake CONFIG-=app_bundle"
    system "make"
    bin.install "CutyCapt"
  end
end
