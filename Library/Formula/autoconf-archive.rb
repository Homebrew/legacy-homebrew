class AutoconfArchive < Formula
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2014.10.15.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2014.10.15.tar.xz"
  sha1 "7efcefd29a67da2a7243ea2b30e353027d70b460"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # gnome_common shares two files with autoconf-archive.
    if Formula["gnome-common"].opt_prefix.exist?
      rm share/"aclocal/ax_check_enable_debug.m4"
      rm share/"aclocal/ax_code_coverage.m4"
    end
  end

  def caveats
    s = ""

    if Formula["gnome-common"].opt_prefix.exist?
      s += <<-EOS.undent
      Due to conflict with gnome-common two files have been removed:
        ax_check_enable_debug.m4 and ax_code_coverage.m4

      Should you remove gnome-common later, you may wish to do:
        `brew reinstall autoconf-archive`
      EOS
    end
    s
  end
end
