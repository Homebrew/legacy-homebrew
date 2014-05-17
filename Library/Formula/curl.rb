require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.36.0.tar.gz'
  mirror 'ftp://ftp.sunet.se/pub/www/utilities/curl/curl-7.36.0.tar.gz'
  sha256 '33015795d5650a2bfdd9a4a28ce4317cef944722a5cfca0d1563db8479840e90'

  bottle do
    cellar :any
    sha1 "0ebc411e07782749c54cbc5d7d63a3c0337db274" => :mavericks
    sha1 "10775d70645f2c9f11ceef6b697be7e825b13d99" => :mountain_lion
    sha1 "10e447d84e269a2ae2707cf58a4cd247680af484" => :lion
  end

  keg_only :provided_by_osx

  option 'with-idn', 'Build with support for Internationalized Domain Names'
  option 'with-rtmp', 'Build with RTMP support'
  option 'with-ssh', 'Build with scp and sftp support'
  option 'with-ares', 'Build with C-Ares async DNS support'
  option 'with-gssapi', 'Build with GSSAPI/Kerberos authentication support.'
  option 'with-libmetalink', 'Build with libmetalink support.'

  if MacOS.version >= :mountain_lion
    option 'with-openssl', 'Build with OpenSSL instead of Secure Transport'
    depends_on 'openssl' => :optional
  else
    depends_on 'openssl'
  end

  depends_on 'pkg-config' => :build
  depends_on 'libidn' if build.with? 'idn'
  depends_on 'libmetalink' => :optional
  depends_on 'libssh2' if build.with? 'ssh'
  depends_on 'c-ares' if build.with? 'ares'
  depends_on 'rtmpdump' if build.with? 'rtmp'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if MacOS.version < :mountain_lion or build.with? "openssl"
      args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
    else
      args << "--with-darwinssl"
    end

    args << (build.with?("ssh") ? "--with-libssh2" : "--without-libssh2")
    args << (build.with?("idn") ? "--with-libidn" : "--without-libidn")
    args << (build.with?("libmetalink") ? "--with-libmetalink" : "--without-libmetalink")
    args << (build.with?("gssapi") ? "--with-gssapi" : "--without-gssapi")
    args << (build.with?("rtmp") ? "--with-librtmp" : "--without-librtmp")

    if build.with? "ares"
      args << "--enable-ares=#{Formula["c-ares"].opt_prefix}"
    else
      args << "--disable-ares"
    end

    system "./configure", *args
    system "make install"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", stable.url, "-o", filename
    filename.verify_checksum stable.checksum
  end
end
