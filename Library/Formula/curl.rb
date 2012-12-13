require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.28.1.tar.gz'
  sha256 '78dce7cfff51ec5725442b92c00550b4e0ca2f45ad242223850a312cd9160509'

  keg_only :provided_by_osx,
            "The libcurl provided by Leopard is too old for CouchDB to use."

  option 'with-ssh', 'Build with scp and sftp support'
  option 'with-libmetalink', 'Build with Metalink support'

  depends_on 'pkg-config' => :build
  depends_on 'libssh2' if build.include? 'with-ssh'
  depends_on 'libmetalink' if build.include? 'with-libmetalink'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--with-libssh2" if build.include? 'with-ssh'
    args << "--with-libmetalink" if build.include? 'with-libmetalink'

    system "./configure", *args
    system "make install"
  end
end
