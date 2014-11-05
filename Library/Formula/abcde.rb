require 'formula'

class Abcde < Formula
  homepage 'http://abcde.einval.com'
  url 'http://abcde.einval.com/download/abcde-2.6.tar.gz'
  sha1 'a1545fb63673e247c8378e9925505e23ace806dc'

  bottle do
    cellar :any
    sha1 "fb1aa6a4cb064c1b6d26ab87f7b7eb1a61388963" => :yosemite
    sha1 "4fd607f7adef90f95d47dae5e1ae43bdbbd3c543" => :mavericks
    sha1 "b98cc145bbbae45421b36721f39f0a5a7a8ee3f7" => :mountain_lion
  end

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
