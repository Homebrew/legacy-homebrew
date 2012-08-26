require 'formula'

class Snappy < Formula
  homepage 'http://snappy.googlecode.com'
  url 'http://snappy.googlecode.com/files/snappy-1.0.5.tar.gz'
  sha1 '3a3df859cf33f78f8e945c3f67f28685f0f38bb1'

  option :universal

  depends_on 'pkg-config' => :build

  def options
    [["--universal", "Builds a universal binary"]]
  end

  def install
<<<<<<< HEAD
    ENV.universal_binary if ARGV.build_universal?
=======
    ENV.universal_binary if build.universal?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
