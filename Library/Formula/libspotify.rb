require 'formula'

class Libspotify < Formula
  url "http://developer.spotify.com/download/libspotify/libspotify-0.0.8-Darwin.zip"
  version '0.0.8'
  homepage 'http://developer.spotify.com/en/libspotify/overview/'
  md5 'a59b824d36e689b7162d067d6e2497a7'

  def install
    prefix.install 'share'
    (include+'libspotify').install "libspotify.framework/Versions/0.0.8/Headers/api.h"
    lib.install "libspotify.framework/Versions/0.0.8/libspotify" => "libspotify.0.0.8.dylib"
    doc.install Dir['doc/*']

    cd lib
    ln_s "libspotify.0.0.8.dylib", "libspotify.dylib"

    system "install_name_tool", "-id",
           "#{HOMEBREW_PREFIX}/lib/libspotify.0.0.8.dylib",
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
