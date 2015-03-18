class Libcouchbase < Formula
  homepage 'http://docs.couchbase.com/developer/c-2.4/c-intro.html'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.4.8.tar.gz'
  sha1 '0c091a7aaf4bc0afa6c680361be3dcdd6a6f7896'
  head "https://github.com/couchbase/libcouchbase", :using => :git

  bottle do
    sha256 "4c9cdc97d7590cfec68ac18b1742fe1ea0905009403daceff4a060fa04b536d6" => :yosemite
    sha256 "3df1f27b09d59364b1861750dee4dedd02da184ccc70a545b0d3f2d5a480b4d9" => :mavericks
    sha256 "9229a54b04fe3f08679446b38b49b84c48d80acb12703bc2e7c2da823905710d" => :mountain_lion
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
