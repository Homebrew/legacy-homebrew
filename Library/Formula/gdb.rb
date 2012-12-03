require 'formula'

class Gdb < Formula
  homepage 'http://www.gnu.org/software/gdb/'
  url 'http://ftpmirror.gnu.org/gdb/gdb-7.5.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gdb/gdb-7.5.1.tar.bz2'
  sha1 'd04c832698ac470a88788e719d19ca7c1d4d803d'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-python=/usr",
                          "--with-system-readline"
    system "make"
    system "make install"
  end

  def patches
    [
      # Support for new Mach-O load commands backported from trunk. This should
      # be unnecessary in GDB 7.6.
      "https://raw.github.com/gist/4197567/dad208436d69ba591200098c91a94fa9e1cdc160/loadcommands.patch",

      # This is a suplemental patch that fixes a small bug in the above patch.
      # It's not in trunk yet, but it has been submitted upstream, okayed, and
      # hopefully a version of it will be committed by the time 7.6 comes out.
      # If you're updating this formula for 7.6, email davidbalbert@gmail.com,
      # and I'll let you know if the change has made it into the release.
      "https://raw.github.com/gist/4197567/e53221895da6bf0e8b307db6e774c24f543db1c3/startaddress.patch"
    ]
  end

  def caveats; <<-EOS.undent
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      http://sourceware.org/gdb/wiki/BuildingOnDarwin
    EOS
  end
end
