require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng16/1.6.3/libpng-1.6.3.tar.gz'
  sha1 'b8b7b911909c09d71324536aaa7750104d170c77'

  keg_only :provided_pre_mountain_lion

  option :universal

  bottle do
    sha1 '5e7feb640d654df0c2ac072d86e46ce9df9eaeee' => :mountain_lion
    sha1 'bbd94d671653943cf21314911978d90f5fb536df' => :lion
    sha1 'fb685cfb8b37b883bf004ee7c9ca785d3435b155' => :snow_leopard
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
