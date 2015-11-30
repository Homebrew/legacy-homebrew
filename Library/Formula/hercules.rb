class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "http://www.hercules-390.eu/"
  url "http://downloads.hercules-390.eu/hercules-3.11.tar.gz"
  sha256 "a75fa0138548f93749991adab954c4a473b961bae23ad06822903df0cf2fd2ca"

  skip_clean :la

  head do
    url "https://github.com/hercules-390/hyperion.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=no"
    system "make"
    system "make", "install"
  end
end
