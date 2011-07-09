require 'formula'

class MediaInfo < Formula
  url 'http://downloads.sourceforge.net/sourceforge/mediainfo/MediaInfo_CLI_0.7.46_GNU_FromSource.tar.bz2'
  homepage 'http://mediainfo.sourceforge.net'
  md5 '06ee9ebad5d450ab4058d04ea8b10850'

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
