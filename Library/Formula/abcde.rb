require 'formula'

class Abcde < Formula
  homepage 'https://code.google.com/p/abcde/'
  url 'http://abcde.googlecode.com/files/abcde-2.5.3.tar.gz'
  sha1 '93e26fc78b742bb7e8b776a8da7b5c8558e2c77e'

  depends_on 'lame' => :optional
  depends_on 'vorbis-tools' => :optional
  depends_on 'flac' => :optional
  depends_on 'cd-discid'
  depends_on 'id3v2'
  depends_on 'cdrtools'
  depends_on 'mkcue'

  def install
    bin.install 'abcde', 'abcde-musicbrainz-tool', 'cddb-tool'
    etc.install 'abcde.conf' unless (etc/'abcde.conf').exist?
    man1.install 'abcde.1', 'cddb-tool.1'
  end
end
