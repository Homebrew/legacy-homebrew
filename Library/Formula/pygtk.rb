require 'formula'

class Pygtk < Formula
  homepage 'http://www.pygtk.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2'
  sha1 '344e6a32a5e8c7e0aaeb807e0636a163095231c2'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'atk'
  depends_on 'pygobject'
  depends_on 'py2cairo'
  depends_on 'libglade' => :optional

  option :universal

  def install
    ENV.append 'CFLAGS', '-ObjC'
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Fixing the pkgconfig file to find codegen, because it was moved from
    # pygtk to pygobject. But our pkgfiles point into the cellar and in the
    # pygtk-cellar there is no pygobject.
    inreplace lib/'pkgconfig/pygtk-2.0.pc', 'codegendir=${datadir}/pygobject/2.0/codegen', "codegendir=#{HOMEBREW_PREFIX}/share/pygobject/2.0/codegen"
    inreplace bin/"pygtk-codegen-2.0", "exec_prefix=${prefix}", "exec_prefix=#{Formula["pygobject"].opt_prefix}"
  end

  test do
    (testpath/"codegen.def").write("(define-enum asdf)")
    system "#{bin}/pygtk-codegen-2.0", "codegen.def"
  end
end
