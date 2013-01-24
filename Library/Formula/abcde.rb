require 'formula'

class Abcde < Formula
  homepage 'https://code.google.com/p/abcde/'
  url 'http://abcde.googlecode.com/files/abcde-2.5.4.tar.gz'
  sha1 'eb0a933f869faf0013bc1382511936797506d108'

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
