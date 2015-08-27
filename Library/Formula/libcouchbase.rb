class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "http://docs.couchbase.com/developer/c-2.4/c-intro.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.5.3.tar.gz"
  sha256 "90bdb48d2f1344429c0d14384b7680a33c786eefb5485e0d1e98cf0e8d7baa16"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "6057410d870897fa6dffaa0f2898e3cbd27bd0030c93913b68ab858cd90d98fd" => :yosemite
    sha256 "81f280e423c69f762d763402419e323ffd072a86eb61776ddb2abd580b75149b" => :mavericks
    sha256 "3dbf0f49fb9c877673348b66a60eb3bd6fa32f5a7939fa17238afa7a41741149" => :mountain_lion
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
