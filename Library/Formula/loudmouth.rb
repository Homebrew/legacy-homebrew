require 'formula'

class Loudmouth <Formula
  url 'http://mcabber.com/files/loudmouth-1.4.3+gitb5a9de5b.20100413.tar.bz2'
  version '1.5.0-pre'
  homepage 'http://www.loudmouth-project.org/'
  md5 'd9693855e1d8226144937decd25633d2'

  head 'git://github.com/engineyard/loudmouth.git'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gnutls' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
