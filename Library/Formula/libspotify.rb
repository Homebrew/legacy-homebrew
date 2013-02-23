require 'formula'

class Libspotify < Formula
  homepage 'http://developer.spotify.com/en/libspotify/overview/'
  url 'https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Darwin-universal.zip'
  sha1 '5a02b7af804661ebff0f4db01a85e91635de8fb3'

  def install
    (include+'libspotify').install "libspotify.framework/Versions/12.1.51/Headers/api.h"
    lib.install "libspotify.framework/Versions/12.1.51/libspotify" => "libspotify.12.1.51.dylib"
    doc.install Dir['docs/*']
    doc.install %w(ChangeLog README LICENSE licenses.xhtml examples)
    man3.install Dir['man3/*']

    lib.cd do
      ln_s "libspotify.12.1.51.dylib", "libspotify.dylib"
      ln_s "libspotify.12.1.51.dylib", "libspotify.12.dylib"
    end

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
