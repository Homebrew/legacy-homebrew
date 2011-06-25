require 'formula'

class Phash < Formula
  url 'http://www.phash.org/releases/pHash-0.9.4.tar.gz'
  homepage 'http://www.phash.org/'
  sha1 '9710b8a1d4d24e7fc3ac43c33eac8e89d9e727d7'

  depends_on 'cimg' unless  ARGV.include? "--disable-image-hash" and ARGV.include? "--disable-video-hash"
  depends_on 'ffmpeg' unless ARGV.include? "--disable-video-hash"

  unless ARGV.include? "--disable-audio-hash"
    depends_on 'libsndfile'
    depends_on 'libsamplerate'
    depends_on 'mpg123'
  end

  def options
    [
     ["--disable-image-hash", "Disable image hash"],
     ["--disable-video-hash", "Disable video hash"],
     ["--disable-audio-hash", "Disable audio hash"]
    ]
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-shared"]

    # disable specific hashes if specified as an option
    args << "--disable-image-hash" if ARGV.include? "--disable-image-hash"
    args << "--disable-video-hash" if ARGV.include? "--disable-video-hash"
    args << "--disable-audio-hash" if ARGV.include? "--disable-audio-hash"

    system "./configure", *args
    system "make install"
  end
end
