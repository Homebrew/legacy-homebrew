require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/ettercap/ettercap/0.7.6-Locard/ettercap-0.7.6.tar.gz'
  sha1 '55818952a8c28beb1b650f3ccc9600a2d784a18f'

  depends_on 'cmake' => :build
  depends_on 'ghostscript' => :build
  depends_on 'pcre'
  depends_on 'libnet'
  depends_on 'curl' # require libcurl >= 7.26.0

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
