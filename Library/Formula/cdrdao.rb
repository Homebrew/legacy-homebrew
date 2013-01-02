require 'formula'

class Cdrdao < Formula
  homepage 'http://cdrdao.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cdrdao/cdrdao/1.2.3/cdrdao-1.2.3.tar.bz2'
  sha1 '70d6547795a1342631c7ab56709fd1940c2aff9f'

  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'libvorbis'
  depends_on 'mad'
  depends_on 'lame'

  fails_with :llvm do
    build 2326
    cause "Segfault while linking"
  end

  # first patch fixes build problems under 10.6
  # see http://sourceforge.net/tracker/index.php?func=detail&aid=2981804&group_id=2171&atid=302171
  # second patch fixes device autodetection on OS X
  # see http://trac.macports.org/ticket/27819
  # upstream bug report:
  # http://sourceforge.net/tracker/?func=detail&aid=3381672&group_id=2171&atid=102171
  def patches
    { :p1 => "http://sourceforge.net/tracker/download.php?group_id=2171&atid=302171&file_id=369387&aid=2981804",
      :p0 => "http://trac.macports.org/export/90637/trunk/dports/sysutils/cdrdao/files/cdrdao-device-default-bufsize.patch" }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
