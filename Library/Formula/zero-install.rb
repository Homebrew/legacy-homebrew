require 'formula'

class ZeroInstall < Formula
  homepage 'http://0install.net/injector.html'
  url 'https://downloads.sf.net/project/zero-install/0install/2.6.2/0install-2.6.2.tar.bz2'
  sha256 '5755226ef4b32f04723bcbe551f4694ddf78dffbb0f589c3140c2d7056370961'

  head 'https://github.com/0install/0install'

  option 'without-gui', "Build without the gui (requires GTK+)"

  depends_on 'gnupg'
  depends_on 'glib' if build.without? 'gui'
  depends_on 'gtk+' if build.with? 'gui'
  depends_on 'gettext' => :build if build.head?
  depends_on 'pkg-config' => :build
  depends_on 'objective-caml' => :build
  depends_on 'opam' => :build

  # Fixes installation if /var is a symlink.
  # Cherry picked from upstream commit.
  patch do
      url "https://github.com/0install/0install/commit/8da5a1f82c108903dfea74553df0779f9f9e6d14.patch"
      sha1 "4ccabd1b18ce07a869ce314c00452ffba070cd86"
  end

  def install
    modules = "yojson xmlm ounit react lwt extlib ssl ocurl"
    modules += " lablgtk" if build.with? 'gui'
    ENV.deparallelize
    ENV['OPAMCURL'] = "curl"
    ENV['OPAMROOT'] = "opamroot"
    ENV['OPAMYES'] = "1"
    ENV['OPAMVERBOSE'] = "1"
    system "opam init --no-setup"
    # Required for lablgtk2 to find Quartz X11 libs.
    ENV.append_path 'PKG_CONFIG_PATH', '/opt/X11/lib/pkgconfig' if build.with? 'gui'
    system "opam install #{modules}"
    system "opam config exec make"
    system "cd dist && ./install.sh #{prefix}"
  end
end
