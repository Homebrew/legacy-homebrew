class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "http://docs.couchbase.com/developer/c-2.4/c-intro.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.5.4.tar.gz"
  sha256 "25916b073556538e8edbb69bd17fcf06c7477ada17a274593f3296561ff1dc4d"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "a0a7cff30d721124a2fec7ec2c5030ac6978fd9e519b288af29a908e1b4bbc9f" => :el_capitan
    sha256 "aa00b9b1757addb1bf2f45112328bbacdd8441cf063f0ea992c8a31e558e0256" => :yosemite
    sha256 "c1876e66669a443ff730d1b7cca9328ce7b5d7f36371b48ca06798d085237117" => :mavericks
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
