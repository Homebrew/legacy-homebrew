require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/communities/c'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.4.3.tar.gz'
  sha1 'a3be2316787f1fcd440806d00efdb023f021495d'

  bottle do
    sha1 "237c350c22cdff767e0cc309abede040b3c50b1b" => :yosemite
    sha1 "be81fc70b47b32c87458a4b70aae70140843bebb" => :mavericks
    sha1 "c44003721d7fe6a24aad62cf21e456f26e3235b1" => :mountain_lion
  end

  option :universal
  option "with-libev", "Build libev plugin"
  option "without-libevent", "Do not build libevent plugin"

  deprecated_option "with-libev-plugin" => "with-libev"
  deprecated_option "without-libevent-plugin" => "without-libevent"

  depends_on "libev" => :optional
  depends_on "libevent" => :recommended
  depends_on "openssl"

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--disable-examples",
      "--disable-tests", # don't download google-test framework
      "--disable-couchbasemock"
    ]

    if build.universal?
      args << "--enable-fat-binary"
      ENV.universal_binary
    end

    if build.without? "libev" and build.without? "libevent"
      # do not do plugin autodiscovery
      args << "--disable-plugins"
    end

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
