require 'formula'

class Opus < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-1.0.2.tar.gz'
  sha1 '37dd3d69b10612cd513ccf26675ef6d61eda24b4'

  head 'https://git.xiph.org/opus.git'

<<<<<<< HEAD
  if ARGV.build_head?
=======
  if build.head?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    depends_on :automake
    depends_on :libtool
  end

  def install
<<<<<<< HEAD
    system "./autogen.sh" if ARGV.build_head?
=======
    system "./autogen.sh" if build.head?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    system "./configure", "--disable-dependency-tracking", "--disable-doc",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
