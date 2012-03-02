require 'formula'

def libcurl?
  ARGV.include? '--with-libcurl'
end

class MediaInfo < Formula
  homepage 'http://mediainfo.sourceforge.net'
  url 'http://downloads.sourceforge.net/mediainfo/MediaInfo_CLI_0.7.53_GNU_FromSource.tar.bz2'
  md5 '0b556ac5370d939a4ee07732bc9281b1'

  def options
    [["--with-libcurl", "Build with libcurl support."]]
  end

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
              "--prefix=#{prefix}"]
      args << "--with-libcurl" if libcurl?
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
