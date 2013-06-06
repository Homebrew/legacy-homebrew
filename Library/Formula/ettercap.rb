require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.github.io/ettercap/'
  url 'http://downloads.sourceforge.net/project/ettercap/ettercap/0.7.6-Locard/ettercap-0.7.6.tar.gz'
  sha1 '55818952a8c28beb1b650f3ccc9600a2d784a18f'

  depends_on 'cmake' => :build
  depends_on 'ghostscript' => :build
  depends_on 'pcre'
  depends_on 'libnet'
  depends_on 'curl' # require libcurl >= 7.26.0

  # fixes absence of strndup function on 10.6 and lower; merged upstream
  def patches
    "https://github.com/Ettercap/ettercap/commit/1692218693ed419465466299c8c76da41c37c945.patch"
  end if MacOS.version < 10.7

  def install
    libnet = Formula.factory 'libnet'

    args = ['..'] + std_cmake_args + [
      "-DINSTALL_SYSCONFDIR=#{etc}",
      '-DENABLE_GTK=OFF',
      "-DHAVE_LIBNET:FILEPATH=#{libnet.opt_prefix}/lib/libnet.dylib"
    ]

    mkdir "build" do
      system "cmake", *args
      system "make install"
    end
  end
end
