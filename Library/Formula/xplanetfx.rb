require "formula"

class Xplanetfx < Formula
  homepage "http://mein-neues-blog.de/xplanetFX/"
  url "http://repository.mein-neues-blog.de:9000/archive/xplanetfx-2.5.27_all.tar.gz"
  sha1 "df1b7e7b8d3dbe890284b598076da2424c94260e"
  version "2.5.27"

  bottle do
    cellar :any
    sha1 "b7c18ca1a1a75ffc7fb5e83590a84461da00af12" => :mavericks
    sha1 "4156ec5f6738c4954819ca74948ee53c0dc26a57" => :mountain_lion
    sha1 "6eb46cc2ffd6fc8937d3979d96892b2a85c6b2a2" => :lion
  end

  option "without-perlmagick", "Build without PerlMagick support - used to check cloud map downloads"
  option "with-gui", "Build to use xplanetFX's GUI... recommended"
  option "with-gnu-sed", "Build to use GNU sed instead of OS X sed"

  depends_on "xplanet"
  depends_on "imagemagick"
  depends_on "wget"
  depends_on "coreutils"
  depends_on "gnu-sed" => :optional
  depends_on "perlmagick" => :recommended

  if build.with? "gui"
    depends_on "librsvg"
    depends_on "pygtk" => "with-libglade"
    depends_on :x11
  end

  skip_clean "share/xplanetFX"

  def install
    inreplace "bin/xplanetFX", "WORKDIR=/usr/share/xplanetFX", "WORKDIR=#{HOMEBREW_PREFIX}/share/xplanetFX"

    prefix.install "bin", "share"

    sPATH = "#{Formula["coreutils"].opt_prefix}/libexec/gnubin"
    sPATH += ":#{Formula["gnu-sed"].opt_prefix}/libexec/gnubin" if build.with?("gnu-sed")
    ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0"
    ENV.prepend_create_path "PERL5LIB", "#{HOMEBREW_PREFIX}/lib/perl5/site_perl/5.16.2" if build.with?("perlmagick")
    ENV.prepend_create_path "GDK_PIXBUF_MODULEDIR", "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders" if build.with?("gui")
    bin.env_script_all_files(libexec+'bin', :PATH => "#{sPATH}:$PATH", :PYTHONPATH => ENV["PYTHONPATH"], :PERL5LIB => ENV["PERL5LIB"], :GDK_PIXBUF_MODULEDIR => ENV["GDK_PIXBUF_MODULEDIR"])
  end

  def post_install
    if build.with?("gui")
      # Change the version directory below with any future update
      ENV["GDK_PIXBUF_MODULEDIR"]="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
      system "#{HOMEBREW_PREFIX}/bin/gdk-pixbuf-query-loaders", "--update-cache"
    end
  end
end
