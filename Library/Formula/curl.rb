require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.27.0.tar.gz'
  sha256 '8cbad34e58608f0e959fe16c7c987e57f5f3dec2c92d1cebb0678f9d668a6867'

  keg_only :provided_by_osx,
            "The libcurl provided by Leopard is too old for CouchDB to use."

  option 'with-ssh', 'Build with scp and sftp support'
  option 'with-libmetalink', 'Build with Metalink support'
  option 'with-ares', 'Build with C-Ares async DNS support'
  option 'with-ssl', 'Build with Homebrew OpenSLL instead of the system version'

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
    args << "--enable-ares=#{`brew --prefix c-ares`}" if build.include? 'with-ares'
    args << "--with-ssl=#{`brew --prefix openssl`}" if build.include? 'with-ssl'

    system "./configure", *args
    system "make install"
  end
end
