require 'formula'

def libcurl?
  ARGV.include? '--with-libcurl'
end

class MediaInfo < Formula
  url 'http://downloads.sourceforge.net/mediainfo/MediaInfo_CLI_0.7.52_GNU_FromSource.tar.bz2'
  homepage 'http://mediainfo.sourceforge.net'
  md5 '088e62c8f2992c776a881fd6813f150f'

  def options
    [["--with-libcurl", "Build with libcurl support."]]
  end

  depends_on 'pkg-config' => :build

  def install
    root_dir = Dir.pwd

    Dir.chdir root_dir + '/ZenLib/Project/GNU/Library'
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"

    Dir.chdir root_dir + "/MediaInfoLib/Project/GNU/Library"
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-libcurl" if libcurl?
    system "./configure", *args
    system "make install"

    Dir.chdir root_dir + "/MediaInfo/Project/GNU/CLI"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
