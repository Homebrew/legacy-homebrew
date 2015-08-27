class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "http://docs.couchbase.com/developer/c-2.4/c-intro.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.5.3.tar.gz"
  sha256 "90bdb48d2f1344429c0d14384b7680a33c786eefb5485e0d1e98cf0e8d7baa16"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "f0a01d9800cbb456371b67f70b955d45232d3175eb9a99db986e530149156288" => :yosemite
    sha256 "36953780faca4da1186a20689a10be198cce674b98e461b3f972a607c4e82ced" => :mavericks
    sha256 "caf7e281e2959aca8395f948a43acc6a784854802d34ec239def94fb4bbf13f9" => :mountain_lion
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
  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DLCB_NO_TESTS=1"

    ["libev", "libevent", "libuv"].each do |pname|
      args << "-DLCB_BUILD_#{pname.upcase}=" + (build.with?("#{pname}") ? "ON" : "OFF")
    end
    if build.universal?
      args << "-DLCB_UNIVERSAL_BINARY=1"
      ENV.universal_binary
    end
    if build.without?("libev") && build.without?("libuv") && build.without?("libevent")
      args << "-DLCB_NO_PLUGINS=1"
    end

    mkdir "LCB-BUILD" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
