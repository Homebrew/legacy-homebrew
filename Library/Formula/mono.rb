require 'formula'

class Mono <Formula
  url "git://github.com/mono/mono.git", :tag => "mono-2-6-7"
  head "git://github.com/mono/mono.git"
  homepage "http://mono-project.com/"
  version "2.6.7"

  depends_on "pkg-config"

  def install
    system "./autogen.sh", "--prefix=#{prefix}",
                           "--with-glib=embedded",
                           "--enable-nls=no"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to build and install Mono you need to have a regular Mono instalation. You can get
    this from:
        http://www.go-mono.com/mono-downloads/download.html

    After installation, if you want to make it the default installation to the system, you can do
    this by setting these environment variables:
      MONO_PREFIX=#{prefix}
      GNOME_PREFIX=/usr
      export LD_LIBRARY_PATH=$MONO_PREFIX/lib:$LD_LIBRARY_PATH
      export C_INCLUDE_PATH=$MONO_PREFIX/include:$GNOME_PREFIX/include
      export ACLOCAL_PATH=$MONO_PREFIX/share/aclocal
      export PKG_CONFIG_PATH=$MONO_PREFIX/lib/pkgconfig:$GNOME_PREFIX/lib/pkgconfig
      export PATH=$MONO_PREFIX/bin:$PATH
      
    It doesn't affect your system. When you want rollback to previous Mono, just remove (or change)
    these environment variables.
    EOS
  end
end