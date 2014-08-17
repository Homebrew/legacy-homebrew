require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/communities/c'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.4.0.tar.gz'
  sha1 '3ce25fa98255967775b4aa4e5b13b7c4ff0a866e'

  bottle do
    sha1 "deea0e789aa2739016a2d9cfb2d7bf9342782775" => :mavericks
    sha1 "912bb53584946c23e80cdcfb8730b8739a70af59" => :mountain_lion
    sha1 "32c9ea13816908b943be75b6a677754dd26c8270" => :lion
  end

  option :universal
  option 'with-libev-plugin', 'Build libev IO plugin (will pull libev dependency)'
  option 'without-libevent-plugin', 'Do not build libevent plugin (will remove libevent dependency)'

  depends_on 'libev' if build.with?('libev-plugin')
  depends_on 'libevent' if build.with?('libevent-plugin')
  depends_on 'openssl'

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
    if build.without?('libev-plugin') && build.without?("libevent-plugin")
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
