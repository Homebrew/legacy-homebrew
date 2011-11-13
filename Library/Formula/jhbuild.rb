require 'formula'

class Jhbuild < Formula
  homepage 'https://live.gnome.org/Jhbuild'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/jhbuild/3.2/jhbuild-3.2.1.tar.bz2'
  sha256 'e9d23b6f6caa9def1dd6cfbe2d1eacf2d4459d4105a17145bd874f573754f286'

  depends_on 'pkg-config'
  depends_on 'intltool'
  depends_on 'gnome-doc-utils'

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def install
    ENV.prepend "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/share/pkgconfig"

    # Disable as much as possible, else installation can be painful
    args = ["--prefix=#{prefix}",
            "--disable-scrollkeeper",
            "--enable-doc-installation=no" ]
    system "./configure", *args

    # Install
    system "make install"
  end
end

