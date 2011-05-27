require 'formula'

class MediaInfo < Formula
  url 'http://downloads.sourceforge.net/sourceforge/mediainfo/MediaInfo_CLI_0.7.44_GNU_FromSource.tar.bz2'
  homepage 'http://mediainfo.sourceforge.net'
  version '0.7.44'
  md5 'cde6700a396514b9954ec0185812dfdc'

  depends_on 'pkg-config' => :build

  def install
    root_dir = Dir.pwd

    Dir.chdir root_dir + '/ZenLib/Project/GNU/Library'
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"

    Dir.chdir root_dir + "/MediaInfoLib/Project/GNU/Library"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

    Dir.chdir root_dir + "/MediaInfo/Project/GNU/CLI"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
