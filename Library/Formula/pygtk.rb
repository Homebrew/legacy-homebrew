class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 1

  bottle do
    revision 1
    sha256 "63291542cf2e40ab92750275c0aeed992224d814b6a455a9d1aed39a55e8fb68" => :el_capitan
    sha256 "1342196c0429a80d128d1369b1f46bb30a37ff345416a466ee9f4cf21d6693f0" => :yosemite
    sha256 "6b0467bd8d5c2377b6d3ff59cef8658a33d5c5800b1d53b23abcdc94aa0f0286" => :mavericks
    sha256 "760447005d79b08046da88b23a9af552bf1a9d039de8a38401e22ef8ed743f49" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+"
  depends_on "atk"
  depends_on "pygobject"
  depends_on "py2cairo"
  depends_on "libglade" => :optional

  def install
    ENV.append "CFLAGS", "-ObjC"
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Fixing the pkgconfig file to find codegen, because it was moved from
    # pygtk to pygobject. But our pkgfiles point into the cellar and in the
    # pygtk-cellar there is no pygobject.
    inreplace lib/"pkgconfig/pygtk-2.0.pc", "codegendir=${datadir}/pygobject/2.0/codegen", "codegendir=#{HOMEBREW_PREFIX}/share/pygobject/2.0/codegen"
    inreplace bin/"pygtk-codegen-2.0", "exec_prefix=${prefix}", "exec_prefix=#{Formula["pygobject"].opt_prefix}"
  end

  test do
    (testpath/"codegen.def").write("(define-enum asdf)")
    system "#{bin}/pygtk-codegen-2.0", "codegen.def"
  end
end
