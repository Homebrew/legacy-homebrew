require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.27.0.tar.gz'
  sha256 '8cbad34e58608f0e959fe16c7c987e57f5f3dec2c92d1cebb0678f9d668a6867'

  keg_only :provided_by_osx,
            "The libcurl provided by Leopard is too old for CouchDB to use."

  depends_on 'pkg-config' => :build
  depends_on 'libssh2' if build.include? 'with-ssh'

  option 'with-ssh', 'Build with scp and sftp support'

  def install
    args = %W[
        --disable-debug
        --disable-dependency-tracking
        --prefix=#{prefix}]

    args << "--with-libssh2" if build.include? 'with-ssh'

    system "./configure", *args
    system "make install"
  end
end
