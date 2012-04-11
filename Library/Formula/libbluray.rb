require 'formula'

class Libbluray < Formula
  homepage 'http://www.videolan.org/developers/libbluray.html'
  head 'git://git.videolan.org/libbluray.git'
  url 'http://static.mouseed.com/src/libbluray/libbluray-0.2.2.tar.bz2'
  mirror 'ftp://ftp.videolan.org/pub/videolan/libbluray/0.2.2/libbluray-0.2.2.tar.bz2'
  md5 'cb3254de43276861ea6b07c603f4651c'

  depends_on 'openssl' if ARGV.include? '--with-openssl'
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def options
    [
      ['--with-openssl', 'install OpenSSL to satisfy dependency']
    ]
  end

  def install
    unless Formula.factory("openssl").installed?
      opoo 'Re-install formula with \'--with-openssl\' option if getting troubles.'
    end

    ohai 'Bootstrapping...'
    quiet_system "./bootstrap"

    config_args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]

    system "./configure", *config_args
    system "make"
    system "make install"
  end
end
