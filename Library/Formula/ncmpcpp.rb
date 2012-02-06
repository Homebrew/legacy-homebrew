require 'formula'

class Ncmpcpp < Formula
  url 'http://unkart.ovh.org/ncmpcpp/ncmpcpp-0.5.8.tar.bz2'
  homepage 'http://unkart.ovh.org/ncmpcpp/'
  md5 '288952c6b4cf4fa3683f3f83a58da37c'

  depends_on 'taglib'
  depends_on 'libmpdclient'
  depends_on 'fftw' if ARGV.include? "--visualizer"

  def options
    [["--visualizer", "Build with visualizer support."]]
  end

  def install
    args = ["--with-taglib",
            "--with-curl",
            "--enable-unicode",
            "--disable-dependency-tracking",
            "LDFLAGS=-liconv",
            "--prefix=#{prefix}"]

    if ARGV.include? "--visualizer"
      args << "--with-fftw"
      args << "--enable-visualizer"
    end

    system "./configure", *args
    system "make install"
  end
end
