require 'formula'

class MediaInfo < Formula
  homepage 'http://mediainfo.sourceforge.net'
  url 'http://downloads.sourceforge.net/mediainfo/MediaInfo_CLI_0.7.60_GNU_FromSource.tar.bz2'
  version '0.7.60'
  sha1 '07d996efcd76fbfcc0787aa2940f5c4971c4537a'

  depends_on 'pkg-config' => :build

  def install
    cd 'ZenLib/Project/GNU/Library' do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end
  end
end
