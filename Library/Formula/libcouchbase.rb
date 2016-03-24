class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "http://docs.couchbase.com/developer/c-2.4/c-intro.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.5.7.tar.gz"
  sha256 "9f8c5269b4af462680092ea62e80ae5b72ec6b11cd51b836242064652774afdf"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "21a28912f714717e31cde98d53b533c0068c5b495a6c026712f5e6162114aacb" => :el_capitan
    sha256 "14d3c09e21add712a4c160b3823270d8e40c486a98d684e392dade5b15852e78" => :yosemite
    sha256 "622eae36d16a1b949db910d157239d6550ae57a5f1cf996c513f637c54cea785" => :mavericks
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
