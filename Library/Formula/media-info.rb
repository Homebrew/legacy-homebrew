require 'formula'

class MediaInfo < Formula
  url 'http://downloads.sourceforge.net/sourceforge/mediainfo/MediaInfo_CLI_0.7.51_GNU_FromSource.tar.bz2'
  homepage 'http://mediainfo.sourceforge.net'
  md5 'b474a089ad26e9db4358ee335498ae43'

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
