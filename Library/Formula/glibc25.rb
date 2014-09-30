require "formula"

class Glibc25 < Formula
  homepage "http://www.gnu.org/software/libc/download.html"
  url "http://ftpmirror.gnu.org/glibc/glibc-2.5.1.tar.bz2"
  sha1 "2b7da136df025bb8c787be3351cba58374226d9c"

  conflicts_with "glibc", :because => "both install libc.so.6"

  depends_on "binutils" => [:build, :optional]
  depends_on "linux-headers" => [:build, :recommended]

  def install
    # Fix result: 2.24, bad
    inreplace "configure", "2.1[3-9]*", "2.1[3-9]*|2.[2-9][0-9]*"

    # Fix Makefile:235: *** mixed implicit and normal rules.  Stop.
    inreplace "manual/Makefile", " $(objpfx)stamp%:", ":\n\ttouch $@\n\n$(objpfx)stamp%:"

    mkdir "build" do
      args = ["--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--without-gd", # Fix error: gd.h: No such file or directory
        "--without-selinux"] # Fix error: selinux/selinux.h: No such file or directory
      args << "--with-binutils=" +
        Formula["binutils"].prefix/"x86_64-unknown-linux-gnu/bin" if build.with? "binutils"
      args << "--with-headers=" +
        Formula["linux-headers"].include if build.with? "linux-headers"
      system "../configure", *args

      system "make" # Fix No rule to make target libdl.so.2 needed by sprof
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end
  end

  def post_install
    # Fix permissions
    system "chmod +x #{lib}/ld-linux-x86-64.so.2 #{lib}/libc.so.6"

    # Compile locale definition files
    mkdir_p lib/"locale"
    locales = ENV.keys.select { |s|
      s == "LANG" || s[/^LC_/]
    }.map { |key| ENV[key] } - ['C']
    locales << "en_US.UTF-8" # Required by gawk make check
    locales.uniq.each { |locale|
      lang, charmap = locale.split(".", 2)
      if charmap != nil
        system bin/"localedef", "-i", lang, "-f", charmap, locale
      else
        system bin/"localedef", "-i", lang, locale
      end
    }
  end

  test do
    system "#{lib}/ld-linux-x86-64.so.2 2>&1 |grep Usage"
    system "#{lib}/libc.so.6 --version"
    system "#{bin}/locale --version"
  end
end
