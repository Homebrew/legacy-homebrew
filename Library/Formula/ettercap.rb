require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.github.io/ettercap/'
  url 'https://github.com/Ettercap/ettercap/archive/534b08bcffd32806d4acbb606128ce6b306451c1.tar.gz'
  sha1 '39ddf82a9f304cec0b15207f796517675a7c0dd4'
  version '0.8.0'
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
      man.mkpath

      system "cmake", *args
      system "make install"
    end
  end
end
