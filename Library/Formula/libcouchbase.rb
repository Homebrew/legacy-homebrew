require 'formula'

class Libcouchbase < Formula
  homepage 'http://docs.couchbase.com/developer/c-2.4/c-intro.html'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.4.6.tar.gz'
  sha1 '2a4ce6b0f6a934a3fa3ef697d26ed6c4737aacae'
  head "https://github.com/couchbase/libcouchbase", :using => :git

  bottle do
    sha1 "82cbd1eb286578eba28b89aa5067702d1310e8bd" => :yosemite
    sha1 "30623f20fa2570c10daa26d6af9ffbf0c588f50e" => :mavericks
    sha1 "3e53951f8a67a90c6eb929856d209ec191e38b2a" => :mountain_lion
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

    ENV["GIT_DIR"] = cached_download/".git" if build.head?
    mkdir 'LCB-BUILD' do
      system "cmake", "..", *args
      system 'make install'
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
