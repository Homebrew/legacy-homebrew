require 'formula'

class Cgminer < Formula
  homepage 'https://github.com/ckolivas/cgminer'
  url 'https://github.com/ckolivas/cgminer/archive/v3.0.1.tar.gz'
  sha1 '8348edd1cb38b5d8e2c459ae77d6081ef38c9b8a'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'coreutils' => :build
  depends_on 'curl'
  depends_on 'jansson'

  def install
    inreplace "autogen.sh", "readlink", "greadlink"
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "PKG_CONFIG_PATH=/usr/local/opt/curl/lib/pkgconfig:/usr/local/opt/jansson/lib/pkgconfig",
                          "--enable-scrypt"
    system "make", "install"
  end

  test do
    system "cgminer"
  end
end
