require 'formula'

class Ncmpcpp < Formula
  url 'http://unkart.ovh.org/ncmpcpp/ncmpcpp-0.5.8.tar.bz2'
  homepage 'http://unkart.ovh.org/ncmpcpp/'
  md5 '288952c6b4cf4fa3683f3f83a58da37c'

  depends_on 'taglib'
  depends_on 'libmpdclient'
  depends_on 'fftw' if ARGV.include? "--visualizer"

  fails_with :clang do
    build 318
  end

  def options
    [
      ["--outputs", "Compile with mpd outputs control"],
      ["--visualizer", "Compile with built-in visualizer"],
      ["--clock", "Compile with optional clock tab"]
    ]
  end

  def install
    ENV.append 'LDFLAGS', '-liconv'
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-taglib",
            "--with-curl",
            "--enable-unicode"]
    args << '--enable-outputs'    if ARGV.include?('--outputs')
    args << '--enable-visualizer' if ARGV.include?('--visualizer')
    args << '--enable-clock'      if ARGV.include?('--clock')

    system "./configure", *args
    system "make install"
  end
end
