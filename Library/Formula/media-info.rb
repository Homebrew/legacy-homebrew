require 'formula'

class MediaInfo < Formula
  homepage 'http://mediainfo.sourceforge.net'
  url 'http://mediaarea.net/download/binary/mediainfo/0.7.68/MediaInfo_CLI_0.7.68_GNU_FromSource.tar.bz2'
  version '0.7.68'
  sha1 '0f458f0f1b34359a20cea29272382c284e796dc2'

  depends_on 'pkg-config' => :build
  # fails to build against Leopard's older libcurl
  depends_on 'curl' if MacOS.version < :snow_leopard

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
