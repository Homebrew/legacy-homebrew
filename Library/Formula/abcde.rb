require 'formula'

class Abcde < Formula
  url 'http://abcde.googlecode.com/files/abcde-2.4.2.tar.gz'
  homepage 'https://code.google.com/p/abcde/'
  md5 '2147527c245ed70af7b218b642201669'

  depends_on 'lame' => :optional
  depends_on 'vorbis-tools' => :optional
  depends_on 'flac' => :optional
  depends_on 'cd-discid'
  depends_on 'id3v2'
  depends_on 'cdrtools'
  depends_on 'mkcue'

  def install
    inreplace 'Makefile', '-o 0', ''
    system "export prefix=#{prefix};export DESTDIR=$prefix;make -e install"
  end
end
