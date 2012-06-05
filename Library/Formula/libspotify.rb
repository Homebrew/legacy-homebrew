require 'formula'

class Libspotify < Formula
  homepage 'http://developer.spotify.com/en/libspotify/overview/'
  url "http://developer.spotify.com/download/libspotify/libspotify-11.1.60-Darwin-universal.zip"
  md5 '655e5648a6b2132df770270257a4c47c'

  def install
    (include+'libspotify').install "libspotify.framework/Versions/11.1.60/Headers/api.h"
    lib.install "libspotify.framework/Versions/11.1.60/libspotify" => "libspotify.11.1.60.dylib"
    doc.install Dir['docs/*']
    man3.install Dir['man3/*']

    cd lib
    ln_s "libspotify.11.1.60.dylib", "libspotify.dylib"
    ln_s "libspotify.11.1.60.dylib", "libspotify.11.dylib"

    system "install_name_tool", "-id",
           "#{HOMEBREW_PREFIX}/lib/libspotify.11.1.60.dylib",
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
