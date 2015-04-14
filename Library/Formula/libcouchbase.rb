class Libcouchbase < Formula
  homepage 'http://docs.couchbase.com/developer/c-2.4/c-intro.html'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.4.9.tar.gz'
  sha1 '9f7f684214a94e1d7ed21493624a2e9140ef0458'
  head "https://github.com/couchbase/libcouchbase", :using => :git

  bottle do
    sha256 "22a5fb1ca35a2efe74bc395e63cb59fe7caf3b55c58b56703aa3ce56c1225333" => :yosemite
    sha256 "9f4fdb45ba9d8036fcfa7e6cd810e3bb97f45ffc79ce20cc0970e62b6565b481" => :mavericks
    sha256 "9d0cf39fa4038d8220d13f17a50f4a80e70e0a28feb11290afcd5e45f884407c" => :mountain_lion
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
