require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.31.0.tar.gz'
  mirror 'ftp://ftp.sunet.se/pub/www/utilities/curl/curl-7.31.0.tar.gz'
  sha256 '2c3a65eecca799f57f57163d40644ba642426230274a2dc51d0a6d049a63616a'

  keg_only :provided_by_osx,
            "The libcurl provided by Leopard is too old for CouchDB to use."

  option 'with-ssh', 'Build with scp and sftp support'
  option 'with-ares', 'Build with C-Ares async DNS support'
  option 'with-ssl', 'Build with Homebrew OpenSSL instead of the system version'
  option 'with-darwinssl', 'Build with Secure Transport for SSL support'

  depends_on 'pkg-config' => :build
  depends_on 'libmetalink' => :optional
  depends_on 'libssh2' if build.with? 'ssh'
  depends_on 'c-ares' if build.with? 'ares'
  depends_on 'openssl' if build.with? 'ssl'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--with-libssh2" if build.with? 'ssh'
    args << "--with-libmetalink" if build.with? 'libmetalink'
    args << "--enable-ares=#{Formula.factory("c-ares").opt_prefix}" if build.with? 'ares'
    args << "--with-ssl=#{Formula.factory("openssl").opt_prefix}" if build.with? 'ssl'
    args << "--with-darwinssl" if build.with? 'darwinssl'

    system "./configure", *args
    system "make install"
  end
end
