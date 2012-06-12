require 'formula'

class Libspotify < Formula
  homepage 'http://developer.spotify.com/en/libspotify/overview/'
  url "https://developer.spotify.com/download/libspotify/libspotify-12.1.45-Darwin-universal.zip"
  md5 '255ae97cb6a108575c66f6fad37a5990'

  def install
    (include+'libspotify').install "libspotify.framework/Versions/12.1.45/Headers/api.h"
    lib.install "libspotify.framework/Versions/12.1.45/libspotify" => "libspotify.12.1.45.dylib"
    doc.install Dir['docs/*']
    doc.install %w(ChangeLog README LICENSE licenses.xhtml examples)
    man3.install Dir['man3/*']

    cd lib
    ln_s "libspotify.12.1.45.dylib", "libspotify.dylib"
    ln_s "libspotify.12.1.45.dylib", "libspotify.12.dylib"

    system "install_name_tool", "-id",
           "#{HOMEBREW_PREFIX}/lib/libspotify.12.1.45.dylib",
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
