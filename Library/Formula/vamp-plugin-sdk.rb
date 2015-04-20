
class VampPluginSdk < Formula
  homepage "http://www.vamp-plugins.org/"
  url "http://sourceforge.net/projects/vamp/files/vamp-plugin-sdk/2.2.1/vamp-plugin-sdk-2.2.1.tar.gz/download"
  version "2.2.1"
  sha256 "571481098270133d2b78c6a461b850e04a98ab38284227c4d8056385f6333c26"

  depends_on 'pkg-config' => :build
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
