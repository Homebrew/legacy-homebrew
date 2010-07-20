require 'formula'

class MzScheme <Formula
  url 'http://download.plt-scheme.org/bundles/4.2.5/mz/mz-4.2.5-src-unix.tgz'
  homepage 'http://plt-scheme.org/'
  md5 '5d320c94e168ab58237c0e710c6050d0'
  version '4.2.5'

  def install
    cd "src"

    options = ["--disable-pthread", "--disable-mred", "--enable-xonx", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]
    options << "--enable-mac64" if Hardware.is_64_bit? && MACOS_VERSION >= 10.6
    system "./configure", *options

    system "make"
    system "make install"
  end
end
