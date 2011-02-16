require 'formula'

class Libspotify <Formula
  version '0.0.7'
  url "http://developer.spotify.com/download/libspotify/libspotify-#{version}-Darwin.zip"
  homepage 'http://developer.spotify.com/en/libspotify/overview/'
  md5 '47e4d355b59aadbd7fad564f5fc172bf'

  def install
    prefix.install 'share'
    (include+'libspotify').install "libspotify.framework/Versions/#{version}/Headers/api.h"
    lib.install "libspotify.framework/Versions/#{version}/libspotify" => "libspotify.#{version}.dylib"
    doc.install Dir['doc/*']

    cd lib
    ln_s "libspotify.#{version}.dylib", "libspotify.dylib"

    system "install_name_tool", "-id",
           "#{HOMEBREW_PREFIX}/lib/libspotify.#{version}.dylib",
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
