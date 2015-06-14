class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage 'http://docs.couchbase.com/developer/c-2.4/c-intro.html'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.5.0.tar.gz'
  sha1 'eb1223e2d3f025006e6fd6717cd63657217e982e'
  head "https://github.com/couchbase/libcouchbase", :using => :git

  bottle do
    sha256 "8a14f6ff932058e030d6ed643593f38f24a3387817cd5fa3900fcc46bef92301" => :yosemite
    sha256 "140deff689bef2980498537b46abce9b783a9f31765f8d98d11d5509ecbaf7df" => :mavericks
    sha256 "574d197231c4bf1a13e6b48bc184085d94b04e0fa6ff89c5363c8062cd53fe6f" => :mountain_lion
  end

  option :universal
  option "with-libev", "Build libev plugin"
  option "without-libevent", "Do not build libevent plugin"

  deprecated_option "with-libev-plugin" => "with-libev"
  deprecated_option "without-libevent-plugin" => "without-libevent"

  depends_on "libev" => :optional
  depends_on "libuv" => :optional
  depends_on "libevent" => :recommended
  depends_on "openssl"
  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << '-DLCB_NO_TESTS=1'

    ['libev', 'libevent', 'libuv'].each do |pname|
        args << "-DLCB_BUILD_#{pname.upcase}=" + (build.with?("#{pname}") ? 'ON' : 'OFF')
    end
    if build.universal?
      args << '-DLCB_UNIVERSAL_BINARY=1'
      ENV.universal_binary
    end
    if build.without?('libev') && build.without?('libuv') && build.without?('libevent')
      args << '-DLCB_NO_PLUGINS=1'
    end

    mkdir 'LCB-BUILD' do
      system "cmake", "..", *args
      system 'make install'
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
