require 'formula'

class Libspotify < Formula
  url "http://developer.spotify.com/download/libspotify/libspotify-10.1.16-Darwin-universal.zip"
  version '10.1.16'
  homepage 'http://developer.spotify.com/en/libspotify/overview/'
  md5 'd26c3f34b7416ffcfdf27b525b7febeb'

  def install
    (include+'libspotify').install "libspotify.framework/Versions/10.1.16/Headers/api.h"
    lib.install "libspotify.framework/Versions/10.1.16/libspotify" => "libspotify.10.1.16.dylib"
    doc.install Dir['docs/*']
    man3.install Dir['man3/*']

    cd lib
    ln_s "libspotify.10.1.16.dylib", "libspotify.dylib"
    ln_s "libspotify.10.1.16.dylib", "libspotify.10.dylib"

    system "install_name_tool", "-id",
           "#{HOMEBREW_PREFIX}/lib/libspotify.10.1.16.dylib",
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
