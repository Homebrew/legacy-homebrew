require 'formula'

class Libcouchbase < Formula
  homepage 'http://docs.couchbase.com/developer/c-2.4/c-intro.html'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.4.5_1_gd7f6ecf.tar.gz'
  sha1 '4b768c141c6007d8221ae9f88e6e223eff320354'
  head "https://github.com/couchbase/libcouchbase", :using => :git

  bottle do
    sha1 "9a7ff0b864146b94ec8dcfe365432f4137557729" => :yosemite
    sha1 "5146a3f780cb89741d72d001406193603bfe788d" => :mavericks
    sha1 "6933915760408fc7c6b0dffadf947f3aeafdf7ff" => :mountain_lion
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
