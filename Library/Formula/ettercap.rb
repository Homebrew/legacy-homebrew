require "formula"

class Ettercap < Formula
  homepage "http://ettercap.github.io/ettercap/"

  stable do
    url "https://github.com/Ettercap/ettercap/archive/v0.8.1.tar.gz"
    sha1 "66362ce69cd9b82b9eb8ea6a52048700704a7d9b"

    # Upstream patch to fix Luajit compile on OS X
    # Both of these patches are already in HEAD.
    # https://github.com/Ettercap/ettercap/pull/618
    # https://github.com/Homebrew/homebrew/issues/33902
    patch do
      url "https://github.com/Ettercap/ettercap/commit/190e4264e3.diff"
      sha1 "4d8cadd8ca19956450e7e2d52f92dc649d393acf"
    end

    patch do
      url "https://github.com/Ettercap/ettercap/commit/e505088db.diff"
      sha1 "db0f121aeba34286c5f6a16e523ac675868b384c"
    end
  end

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
  depends_on "gtk+" => :optional
  depends_on "luajit" => :optional
  depends_on "openssl"

  def install
    args = std_cmake_args

    # specify build type manually since std_cmake_args sets the build type to "None".
    args << "-DCMAKE_BUILD_TYPE=Release"

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
end
