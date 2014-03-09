require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.github.io/ettercap/'
  url 'https://github.com/Ettercap/ettercap/archive/v0.8.0.tar.gz'
  sha1 '008fca94bbd67b578699300eb321766cd41fbfff'

  head 'https://github.com/Ettercap/ettercap.git'

  option 'without-curses', 'Install without curses interface'
  option 'without-plugins', 'Install without plugins support'
  option 'with-ipv6', 'Install with IPv6 support'
  option 'with-debug', 'Enable debug mode'
  
  depends_on 'cmake' => :build
  depends_on 'ghostscript' => :build
  depends_on 'pcre'
  depends_on 'libnet'
  depends_on 'curl' # require libcurl >= 7.26.0
  depends_on 'gtk+' => :optional
  depends_on 'luajit' => :optional

  def patches
    [
      # Fixes issue #326: redefinition of 'bpf_program', 'bpf_version', 
      #  and 'bpf_insn' in ec_send.c on Mac OS X
      # url: https://github.com/Ettercap/ettercap/issues/326
      "https://github.com/Ettercap/ettercap/commit/4aaaa2fb6a4ea98e110548802ed015694244b90e.patch",
      # Fixes issue #344: undefined symbol safe_free_mem caused by the previous fix.
      # url: https://github.com/Ettercap/ettercap/issues/344
      "https://github.com/Ettercap/ettercap/commit/33ac95f78e4f6f067e6bc33b8883b3b7daa896f3.patch"
    ]
  end

  def install
    build_type = build.with? "debug" ? "Debug" : "Release" 

    args = std_cmake_args
    args << "-DINSTALL_SYSCONFDIR=#{etc}"
    args << ("-DCMAKE_BUILD_TYPE=#{build_type}"
    args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    args << "-DENABLE_CURSES=OFF" if build.without? "curses"
    args << "-DENABLE_PLUGINS=OFF" if build.without? "plugins"
    args << "-DENABLE_IPV6=ON" if build.with? "ipv6"
    args << "-DENABLE_GTK=OFF" if build.without? "gtk+"
    args << "-DENABLE_LUA=ON" if build.with? "luajit"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make install"
    end
  end
end

