require "formula"

class Xplanetfx < Formula
  homepage "http://mein-neues-blog.de/xplanetFX/"
  url "http://repository.mein-neues-blog.de:9000/archive/xplanetfx-2.5.25_all.tar.gz"
  sha1 "7f82fd31d39c3edbc729c7e778e4e364edde56a0"
  version "2.5.25"

  option "without-perlmagick", "Build without PerlMagick support - used to check cloud map downloads"
  option "without-gui", "Build to run xplanetFX only from the command-line"

  depends_on "xplanet"
  depends_on "imagemagick"
  depends_on "wget"
  depends_on :python
  depends_on "coreutils"
  depends_on "gnu-sed"

  depends_on "perlmagick" => :recommended

  if build.with? "gui"
    depends_on "librsvg"
    depends_on "pygtk" => "with-libglade"
  end

  depends_on :x11

  skip_clean "share/xplanetFX"

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0"

    if build.with?("perlmagick")
      ENV.prepend_create_path "PERL5LIB", "#{Dir.glob("#{HOMEBREW_PREFIX}/lib/perl5/site_perl/**")}"
    end

    sUpdate_Loader=""
    if build.with?("gui")
      ENV.prepend_create_path "GDK_PIXBUF_MODULEDIR", "#{Dir.glob(File.join ("#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/**", "loaders"))}"
      sUpdate_Loader="#{Formula["gdk-pixbuf"].bin}/gdk-pixbuf-query-loaders --update-cache"
    end

    inreplace "bin/xplanetFX", "WORKDIR=/usr/share/xplanetFX", "WORKDIR=#{HOMEBREW_PREFIX}/share/xplanetFX"

    libexec.install "bin"
    prefix.install "share"
    (bin/"xplanetFX").write <<-EOS.undent
      #!/bin/bash
      export PYTHONPATH="#{ENV["PYTHONPATH"]}"
      export PERL5LIB="#{ENV["PERL5LIB"]}"
      export GDK_PIXBUF_MODULEDIR="#{ENV["GDK_PIXBUF_MODULEDIR"]}"
      #{sUpdate_Loader}
      exec "#{libexec}/bin/xplanetFX" "$@"
    EOS
  end
end
