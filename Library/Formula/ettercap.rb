class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.2.tar.gz"
  sha256 "f38514f35bea58bfe6ef1902bfd4761de0379942a9aa3e175fc9348f4eef2c81"

  bottle do
    sha256 "4a7516b3e6528c6fc88deb64e48f2da4afc71e5e86565933fba27d4133bd418a" => :el_capitan
    sha256 "1c6bc00b1f7dc226fb6378669c4704de9a190439ba1edef083fb9178d09faac0" => :yosemite
    sha256 "b51137d64a04f49737a639f097dc725e2ffc36ec7dd52295bdafd7db9ea4dff7" => :mavericks
    sha256 "4a2f65a3d3606b465f0bab5cb1c27a5599815a23bb59a4ba126f8ed9fdf60a9f" => :mountain_lion
  end

  head "https://github.com/Ettercap/ettercap.git"

  option "without-curses", "Install without curses interface"
  option "without-plugins", "Install without plugins support"
  option "with-ipv6", "Install with IPv6 support"

  depends_on "cmake" => :build
  depends_on "ghostscript" => [:build, :optional]
  depends_on "pcre"
  depends_on "libnet"
  depends_on "curl" # require libcurl >= 7.26.0
  depends_on "openssl"
  depends_on "gtk+" => :optional
  depends_on "luajit" => :optional

  def install
    args = std_cmake_args

    args << "-DINSTALL_SYSCONFDIR=#{etc}"
    args << "-DENABLE_CURSES=OFF" if build.without? "curses"
    args << "-DENABLE_PLUGINS=OFF" if build.without? "plugins"
    args << "-DENABLE_IPV6=ON" if build.with? "ipv6"
    args << "-DENABLE_PDF_DOCS=ON" if build.with? "ghostscript"
    args << "-DENABLE_GTK=OFF" if build.without? "gtk+"
    args << "-DENABLE_LUA=ON" if build.with? "luajit"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    system bin/"ettercap", "--version"
  end
end
