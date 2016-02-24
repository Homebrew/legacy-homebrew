class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "http://docs.couchbase.com/developer/c-2.4/c-intro.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.5.6.tar.gz"
  sha256 "5e82f744ffa9d8ac02dc6fde3a2b2e91995c4f71351c7bf12bbc3571357660b6"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "0811913a3d712ceb06aaa57dbb7a5833b727c39a22a23cbcd3acd5d479d4e724" => :el_capitan
    sha256 "d1433548d98ca5d031bbbfae3d76343ee8be34d38efbbd2cd3fd3fdc4e809ae3" => :yosemite
    sha256 "fb4bbb0ae4e2b5ab6befc22a38c9c0829d849cc4a858b2a394a4f90fb24e91e6" => :mavericks
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
