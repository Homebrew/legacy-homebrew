require 'formula'

class Binutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.gz'
  sha1 '1b2bc33003f4997d38fadaa276c1f0321329ec56'

  # No --default-names option as it interferes with Homebrew builds.

  bottle do
    sha1 "b411f528adb58ccdf068832b84f35da97e510ec9" => :mavericks
    sha1 "506dcb201baa8cf6ffed975c993335f7a48389a1" => :mountain_lion
    sha1 "2726d3a479491570b01fd707e14fabf97185271e" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
  end

  test do
    assert `#{bin}/gnm #{bin}/gnm`.include? 'main'
    assert_equal 0, $?.exitstatus
  end
end
