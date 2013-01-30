require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/ettercap/ettercap/0.7.5-Assimilation/ettercap-0.7.5.2.tar.gz'
  sha1 'c0b7798c6ff95b04402042956e62e2e984ba48d5'

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
