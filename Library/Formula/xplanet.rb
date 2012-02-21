require 'formula'

class Xplanet < Formula
  url 'http://sourceforge.net/projects/xplanet/files/xplanet/1.2.2/xplanet-1.2.2.tar.gz'
  homepage 'http://xplanet.sourceforge.net/'
  md5 'b38c3b4cfdd772643f876a9bb15f288b'

  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libtiff'

  def options
    [
      ["--with-x", "Build for X11 instead of Aqua."],
    ]
  end

  def install
    ENV.x11 # So we can see the system libpng
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    if ARGV.include? "--with-x"
        args << "--with-x"
    else
        args << "--with-aqua" << "--without-x"
    end

    system "./configure", *args
    system "make install"
  end
end
