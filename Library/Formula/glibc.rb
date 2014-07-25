require "formula"

class Glibc < Formula
  homepage "http://www.gnu.org/software/libc/download.html"
  url "http://ftpmirror.gnu.org/glibc/glibc-2.19.tar.bz2"
  sha1 "382f4438a7321dc29ea1a3da8e7852d2c2b3208c"

  # binutils 2.20 or later is required
  depends_on "binutils" => [:build, :optional]

  # Linux kernel headers 2.6.19 or later are required
  depends_on "linux-headers" => [:build, :optional]

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
      rm include/"libintl.h" # Conflicts with gettext
      rm_rf include/"scsi" # Conflicts with linux-headers
    end
  end

  test do
    system "#{bin}/locale --version"
  end
end
