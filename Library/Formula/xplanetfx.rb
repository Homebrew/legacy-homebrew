class Xplanetfx < Formula
  desc "Configure, run or daemonize xplanet for HQ Earth wallpapers"
  homepage "http://mein-neues-blog.de/xplanetFX/"
  url "http://repository.mein-neues-blog.de:9000/archive/xplanetfx-2.6.7_all.tar.gz"
  sha256 "c3bbe4c195263688400d527dddf5ac2e0e12e2ad21b762f34f7ee98dc635c7e3"
  version "2.6.7"

  bottle do
    cellar :any
    revision 1
    sha256 "d0df69f6cd30618e953e4474e196fa8221d3d984b5ffe1aef933616caced9b05" => :yosemite
    sha256 "89b74842859932646369a6c0aae9356a7b124e142ec04fe564a40e28c81fd115" => :mavericks
    sha256 "760a9f132f462b274a9068a21bfe1f806c295fbd1bb5fdb02a5de433dd7e2efe" => :mountain_lion
  end

  option "without-gui", "Build to run xplanetFX from the command-line only"
  option "with-gnu-sed", "Build to use GNU sed instead of OS X sed"

  depends_on "xplanet"
  depends_on "imagemagick"
  depends_on "wget"
  depends_on "coreutils"
  depends_on "gnu-sed" => :optional

  if build.with? "gui"
    depends_on "librsvg"
    depends_on "pygtk" => "with-libglade"
  end

  skip_clean "share/xplanetFX"

  def install
    inreplace "bin/xplanetFX", "WORKDIR=/usr/share/xplanetFX", "WORKDIR=#{HOMEBREW_PREFIX}/share/xplanetFX"

    prefix.install "bin", "share"

    path = "#{Formula["coreutils"].opt_libexec}/gnubin"
    path += ":#{Formula["gnu-sed"].opt_libexec}/gnubin" if build.with?("gnu-sed")
    if build.with?("gui")
      ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0"
      ENV.prepend_create_path "GDK_PIXBUF_MODULEDIR", "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    end
    bin.env_script_all_files(libexec+"bin", :PATH => "#{path}:$PATH", :PYTHONPATH => ENV["PYTHONPATH"], :GDK_PIXBUF_MODULEDIR => ENV["GDK_PIXBUF_MODULEDIR"])
  end

  def post_install
    if build.with?("gui")
      # Change the version directory below with any future update
      ENV["GDK_PIXBUF_MODULEDIR"]="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
      system "#{HOMEBREW_PREFIX}/bin/gdk-pixbuf-query-loaders", "--update-cache"
    end
  end

  test do
    system "#{bin}/xplanetFX", "--help"
  end
end
