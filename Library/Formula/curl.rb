require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.29.0.tar.gz'
  sha256 '67dc5b952ac489191b62dbe95b18d336b821649f61404a280186c72e8cd0b9d6'

  keg_only :provided_by_osx,
            "The libcurl provided by Leopard is too old for CouchDB to use."

  option 'with-ssh', 'Build with scp and sftp support'
  option 'with-libmetalink', 'Build with Metalink support'
  option 'with-ares', 'Build with C-Ares async DNS support'
  option 'with-ssl', 'Build with Homebrew OpenSSL instead of the system version'

  depends_on 'pkg-config' => :build
  depends_on 'libssh2' if build.include? 'with-ssh'
  depends_on 'libmetalink' if build.include? 'with-libmetalink'
  depends_on 'c-ares' if build.include? 'with-ares'
  depends_on 'openssl' if build.include? 'with-ssl'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--with-libssh2" if build.include? 'with-ssh'
    args << "--with-libmetalink" if build.include? 'with-libmetalink'
    args << "--enable-ares=#{Formula.factory("c-ares").opt_prefix}" if build.include? 'with-ares'
    args << "--with-ssl=#{Formula.factory("openssl").opt_prefix}" if build.include? 'with-ssl'

    system "./configure", *args
    system "make install"
  end
end
