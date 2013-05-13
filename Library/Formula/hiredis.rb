require 'formula'

class Hiredis < Formula
  homepage 'https://github.com/redis/hiredis'
  url 'https://github.com/redis/hiredis/archive/v0.11.0.tar.gz'
  sha1 '694b6d7a6e4ea7fb20902619e9a2423c014b37c1'

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    system "make", "install", "PREFIX=#{prefix}"
    (lib+'pkgconfig/hiredis.pc').write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{opt_prefix}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include

    Name: Hiredis
    Description: Minimalistic C client for Redis >= 1.2
    Version: #{version}
    Libs: -L${libdir} -lhiredis
    Cflags: -I${includedir}
    EOS
  end
end
