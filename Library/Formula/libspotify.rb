require 'formula'

class Libspotify < Formula
  url "http://developer.spotify.com/download/libspotify/libspotify-9.1.32-Darwin-universal.tar.gz"
  version '9.1.32'
  homepage 'http://developer.spotify.com/en/libspotify/overview/'
  md5 '6a98f3198430f426cf7cd1c3ed90c553'

  def install
    (include+'libspotify').install "libspotify.framework/Versions/9/Headers/api.h"
    lib.install "libspotify.framework/Versions/9/libspotify" => "libspotify.9.1.32.dylib"
    doc.install Dir['doc/*']
    man3.install Dir['man/man3/man3spotify/*']

    cd lib
    ln_s "libspotify.9.1.32.dylib", "libspotify.dylib"
    ln_s "libspotify.9.1.32.dylib", "libspotify.9.dylib"

    system "install_name_tool", "-id",
           "#{HOMEBREW_PREFIX}/lib/libspotify.9.1.32.dylib",
           "libspotify.dylib"

    (lib+'pkgconfig/libspotify.pc').write pc_content
  end

  def pc_content; <<-EOS.undent
    prefix=#{HOMEBREW_PREFIX}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include

    Name: libspotify
    Description: Spotify client library
    Version: #{version}
    Libs: -L${libdir} -lspotify
    Cflags: -I${includedir}
    EOS
  end
end
