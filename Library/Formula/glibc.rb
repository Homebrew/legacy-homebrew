require "formula"

class Glibc < Formula
  homepage "http://www.gnu.org/software/libc/download.html"
  url "http://ftpmirror.gnu.org/glibc/glibc-2.19.tar.bz2"
  sha1 "382f4438a7321dc29ea1a3da8e7852d2c2b3208c"

  # binutils 2.20 or later is required
  depends_on "binutils" => [:build, :recommended]

  # Linux kernel headers 2.6.19 or later are required
  depends_on "linux-headers" => [:build, :recommended]

  def install
    mkdir "build" do
      args = ["--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
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
    }.map { |key| ENV[key] }
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
