require 'formula'

class VampPluginSdk < Formula
  homepage 'http://downloads.sourceforge.net/vamp/vamp-plugin-sdk-2.5.tar.gz'
  url 'http://code.soundsoftware.ac.uk/attachments/download/690/vamp-plugin-sdk-2.5.tar.gz'
  sha1 'e87292c5d02f4c562e269188c43500958b0ea65a'

  depends_on 'pkg-config'
  depends_on 'libsndfile'

  def patches
    # uncomment osx specific items in Makefile.in
    # add -dylib_install_name call to fix library path
    {:p1 => [
        "http://gist.github.com/raw/462794/2f99c9305a77893974d97045860d8e61fb4d0c40/osx_settings",
        "http://gist.github.com/raw/462794/86ae51b2e94b075aa2652869749e6b660badf0c1/fix_library_paths"
    ]}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
