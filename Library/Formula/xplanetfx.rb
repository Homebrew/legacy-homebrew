require "formula"

class Xplanetfx < Formula
  homepage "http://mein-neues-blog.de/xplanetFX/"
  url "http://repository.mein-neues-blog.de:9000/archive/xplanetfx-2.5.33_all.tar.gz"
  sha1 "48f9ab95aad8ee990aac7465d7f00c1d1931a8eb"
  version "2.5.33"

  bottle do
    cellar :any
    sha1 "405addc419e4e61202706d984e7b4c68204f0d4c" => :mavericks
    sha1 "93284f0dd9e525bf5561abf542fda1ad8e5a79b2" => :mountain_lion
    sha1 "8874574087f4766366491c006b83b0186f01ae0d" => :lion
  end

  option "without-perlmagick", "Build without PerlMagick support - used to check cloud map downloads"
  option "without-gui", "Build to run xplanetFX from the command-line only"
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
  end

  skip_clean "share/xplanetFX"

  def install
    inreplace "bin/xplanetFX", "WORKDIR=/usr/share/xplanetFX", "WORKDIR=#{HOMEBREW_PREFIX}/share/xplanetFX"

    prefix.install "bin", "share"

    sPATH = "#{Formula["coreutils"].opt_prefix}/libexec/gnubin"
    sPATH += ":#{Formula["gnu-sed"].opt_prefix}/libexec/gnubin" if build.with?("gnu-sed")
    ENV.prepend_create_path "PERL5LIB", "#{HOMEBREW_PREFIX}/lib/perl5/site_perl/5.16.2" if build.with?("perlmagick")
    if build.with?("gui")
      ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0"
      ENV.prepend_create_path "GDK_PIXBUF_MODULEDIR", "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    end
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
