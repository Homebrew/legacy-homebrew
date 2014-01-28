require 'formula'

class MediaInfo < Formula
  homepage 'http://mediainfo.sourceforge.net'
  url 'http://mediaarea.net/download/binary/mediainfo/0.7.65/MediaInfo_CLI_0.7.65_GNU_FromSource.tar.bz2'
  version '0.7.65'
  sha1 '8b24e118d99cbe5066d96bd3e4f9a23d45fb2cf2'

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
