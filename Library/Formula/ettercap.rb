require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.github.io/ettercap/'
  url 'https://github.com/Ettercap/ettercap/archive/v0.8.0.tar.gz'
  sha1 '008fca94bbd67b578699300eb321766cd41fbfff'

  head 'https://github.com/Ettercap/ettercap.git'

  option 'without-curses', 'Install without curses interface'
  option 'without-plugins', 'Install without plugins support'
  option 'with-ipv6', 'Install with IPv6 support'
  option 'enable-debug', 'Enable debug mode'
  
  depends_on 'cmake' => :build
  depends_on 'ghostscript' => :build
  depends_on 'pcre'
  depends_on 'libnet'
  depends_on 'curl' # require libcurl >= 7.26.0
  depends_on 'gtk+' => :optional
  depends_on 'luajit' => :optional

  # 0.8.0 won't build without these patches.
  def patches
    [
      "https://github.com/Ettercap/ettercap/commit/4aaaa2fb6a4ea98e110548802ed015694244b90e.patch",
      "https://github.com/Ettercap/ettercap/commit/33ac95f78e4f6f067e6bc33b8883b3b7daa896f3.patch"
    ]
  end

  def install
    args = [".."] + std_cmake_args
    args << "-DINSTALL_SYSCONFDIR=" + etc
    args << ("-DCMAKE_BUILD_TYPE=" +  ((build.include? "enable-debug") ? "Debug" : "Release"))
    args << "-DCMAKE_INSTALL_PREFIX=" + prefix
    args << "-DENABLE_CURSES=OFF" if build.include? "without-curses"
    args << "-DENABLE_PLUGINS=OFF" if build.include? "wihtout-plugins"
    args << "-DENABLE_IPV6=ON" if build.include? "with-ipv6"
    args << "-DENABLE_GTK=OFF" if build.without? "gtk+"
    args << "-DENABLE_LUA=ON" if build.with? "luajit" 

    mkdir "build" do
      system "cmake", *args
      system "make install"
    end
  end
end