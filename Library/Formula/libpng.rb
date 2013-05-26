require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://download.sourceforge.net/libpng/libpng-1.6.2.tar.gz'
  sha1 'd10af2004e7608425cbb8a8a99209a27af276ff7'

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
