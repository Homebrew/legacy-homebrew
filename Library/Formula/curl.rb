require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.26.0.tar.bz2'
  sha256 'fced262f16eb6bfcdcea15e04a7905ffcb5ff04b14a19ca35b9df86d6720d26a'

  keg_only :provided_by_osx,
            "The libcurl provided by Leopard is too old for CouchDB to use."

  depends_on 'pkg-config' => :build
  depends_on 'libssh2' if ARGV.include? "--with-ssh"

  def options
    [["--with-ssh", "Build with scp and sftp support."]]
  end

  def install
    args = %W[
        --disable-debug
        --disable-dependency-tracking
        --prefix=#{prefix}]

    args << "--with-libssh2" if ARGV.include? "--with-ssh"

    system "./configure", *args
    system "make install"
  end
end
