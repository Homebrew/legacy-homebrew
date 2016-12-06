require 'formula'

class VampPluginSdk <Formula
  url 'http://downloads.sourceforge.net/vamp/vamp-plugin-sdk-2.1.tar.gz'
  homepage 'http://vamp-plugins.org'
  md5 '13252077a73987dae72a9174e529b6b9'

  depends_on 'pkg-config'
  depends_on 'libsndfile'

  def patches
    # uncomment osx specific items in Makefile.in
    # add -dylib_install_name call to fix library path
    {:p1 => ["http://gist.github.com/raw/462794/2f99c9305a77893974d97045860d8e61fb4d0c40/osx_settings",
             "http://gist.github.com/raw/462794/86ae51b2e94b075aa2652869749e6b660badf0c1/fix_library_paths"]}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
