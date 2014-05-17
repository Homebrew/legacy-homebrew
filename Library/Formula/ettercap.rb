require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.github.io/ettercap/'

  stable do
    url "https://github.com/Ettercap/ettercap/archive/v0.8.0.tar.gz"
    sha1 "008fca94bbd67b578699300eb321766cd41fbfff"

    patch do
      # Fixes issue #326: redefinition of 'bpf_program', 'bpf_version',
      #  and 'bpf_insn' in ec_send.c on Mac OS X.
      # url: https://github.com/Ettercap/ettercap/issues/326
      url "https://github.com/Ettercap/ettercap/commit/4aaaa2.diff"
      sha1 "c1c78b38f3f1ffcdbb1d16a292c0fc6d96991ed0"
    end

    patch do
      # Fixes issue #344: undefined symbol safe_free_mem caused by the previous fix.
      # url: https://github.com/Ettercap/ettercap/issues/344
      url "https://github.com/Ettercap/ettercap/commit/33ac95.diff"
      sha1 "cdaff33bec2a73e2c44230c28f3727b8f36e45e2"
    end
  end

  head "https://github.com/Ettercap/ettercap.git"

  option "without-curses", "Install without curses interface"
  option "without-plugins", "Install without plugins support"
  option "with-ipv6", "Install with IPv6 support"

  depends_on 'cmake' => :build
  depends_on 'ghostscript' => [:build, :optional]
  depends_on 'pcre'
  depends_on 'libnet'
  depends_on 'curl' # require libcurl >= 7.26.0
  depends_on 'gtk+' => :optional
  depends_on 'luajit' => :optional

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
      system "make install"
    end
  end
end
