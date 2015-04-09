class Ettercap < Formula
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.2.tar.gz"
  sha256 "f38514f35bea58bfe6ef1902bfd4761de0379942a9aa3e175fc9348f4eef2c81"

  bottle do
    sha1 "b7d7bfc3d98015cea228473b239a0fe9ae41127d" => :yosemite
    sha1 "15b7682fbba8687cfaa8effd00b7f6dd0ced8e91" => :mavericks
    sha1 "d221416cc95911a965ea1821b1a218531b4ea349" => :mountain_lion
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
