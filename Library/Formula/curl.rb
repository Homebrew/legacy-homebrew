require "formula"

class Curl < Formula
  homepage "http://curl.haxx.se/"
  url "http://curl.haxx.se/download/curl-7.39.0.tar.bz2"
  mirror "ftp://ftp.sunet.se/pub/www/utilities/curl/curl-7.39.0.tar.bz2"
  sha256 "b222566e7087cd9701b301dd6634b360ae118cc1cbc7697e534dc451102ea4e0"

  bottle do
    cellar :any
    sha1 "ecb492c18c73bd4beb64b9b16d817bdef0f1b989" => :yosemite
    sha1 "581f76814f982c87e6d281a55efd0da75f8e26e6" => :mavericks
    sha1 "fb53da99991975bfdbc8d4c7e7e967ae4c0329b6" => :mountain_lion
  end

  keg_only :provided_by_osx

  option "with-libidn", "Build with support for Internationalized Domain Names"
  option "with-rtmpdump", "Build with RTMP support"
  option "with-libssh2", "Build with scp and sftp support"
  option "with-c-ares", "Build with C-Ares async DNS support"
  option "with-gssapi", "Build with GSSAPI/Kerberos authentication support."
  option "with-libmetalink", "Build with libmetalink support."
  option "with-libressl", "Build with LibreSSL instead of Secure Transport or OpenSSL"

  deprecated_option "with-idn" => "with-libidn"
  deprecated_option "with-rtmp" => "with-rtmpdump"
  deprecated_option "with-ssh" => "with-libssh2"
  deprecated_option "with-ares" => "with-c-ares"

  if MacOS.version >= :mountain_lion
    option "with-openssl", "Build with OpenSSL instead of Secure Transport"
    depends_on "openssl" => :optional
  else
    depends_on "openssl"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "libssh2" => :optional
  depends_on "c-ares" => :optional
  depends_on "libmetalink" => :optional
  depends_on "libressl" => :optional

  def install
    # Throw an error if someone actually tries to rock both SSL choices.
    # Long-term, make this singular-ssl-option-only a requirement.
    if build.with? "libressl" and build.with? "openssl"
      ohai <<-EOS.undent
      --with-openssl and --with-libressl are both specified and
      curl can only use one at a time; proceeding with openssl.
      EOS
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if MacOS.version < :mountain_lion or build.with? "openssl"
      args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
      args << "--with-ca-bundle=#{etc}/openssl/cert.pem"
    elsif build.with? "libressl"
      args << "--with-ssl=#{Formula["libressl"].opt_prefix}"
      args << "--with-ca-bundle=#{etc}/libressl/cert.pem"
    else
      args << "--with-darwinssl"
    end

    args << (build.with?("libssh2") ? "--with-libssh2" : "--without-libssh2")
    args << (build.with?("libidn") ? "--with-libidn" : "--without-libidn")
    args << (build.with?("libmetalink") ? "--with-libmetalink" : "--without-libmetalink")
    args << (build.with?("gssapi") ? "--with-gssapi" : "--without-gssapi")
    args << (build.with?("rtmpdump") ? "--with-librtmp" : "--without-librtmp")

    if build.with? "c-ares"
      args << "--enable-ares=#{Formula["c-ares"].opt_prefix}"
    else
      args << "--disable-ares"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", stable.url, "-o", filename
    filename.verify_checksum stable.checksum
  end
end
