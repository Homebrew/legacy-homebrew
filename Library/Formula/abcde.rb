require 'formula'

class Abcde < Formula
  homepage 'http://abcde.einval.com'
  url 'http://abcde.einval.com/download/abcde-2.6.tar.gz'
  sha1 'a1545fb63673e247c8378e9925505e23ace806dc'

  depends_on 'cd-discid'
  depends_on 'cdrtools'
  depends_on 'id3v2'
  depends_on 'mkcue'
  depends_on 'flac' => :optional
  depends_on 'lame' => :optional
  depends_on 'vorbis-tools' => :optional

  def install
    bin.install 'abcde', 'abcde-musicbrainz-tool', 'cddb-tool'
    etc.install 'abcde.conf'
    man1.install 'abcde.1', 'cddb-tool.1'
  end
end
