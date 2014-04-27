require 'formula'

class Solfege < Formula
  homepage 'http://www.solfege.org/'
  url 'http://ftpmirror.gnu.org/solfege/solfege-3.20.6.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/solfege/solfege-3.20.6.tar.xz'
  sha1 '0b83f351e90aeb9267f76d8dda0638dc50682226'

  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "gdk-pixbuf" => "with-update-cache"
  depends_on "pygtk" => :recommended
  depends_on "qtplay" => :recommended
  depends_on "librsvg" => :recommended
  depends_on "vorbis-tools" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    inreplace "#{bin}/solfege", "os.path.split(os.path.dirname(os.path.abspath(sys.argv[0])))[0]", "\"#{prefix}\""

    ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0"
    ENV.prepend_create_path "GDK_PIXBUF_MODULEDIR", "#{Dir.glob(File.join ("#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/**", "loaders"))}"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV["PYTHONPATH"], :GDK_PIXBUF_MODULEDIR => ENV["GDK_PIXBUF_MODULEDIR"])
  end

  def post_install
    ENV["GDK_PIXBUF_MODULEDIR"]="#{Dir.glob(File.join ("#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/**", "loaders"))}"
    system "#{Formula["gdk-pixbuf"].bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  def caveats
    <<-EOS.undent
      You can go into Solfege Preferences and set your external programs to qtplay
      and ogg123 which get installed as dependencies, or you can use your own apps.
    EOS
  end
end
