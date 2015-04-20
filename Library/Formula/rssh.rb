require "formula"

class Rssh < Formula
  homepage "http://www.pizzashack.org/rssh"
  url "https://downloads.sourceforge.net/project/rssh/rssh/2.3.4/rssh-2.3.4.tar.gz"
  sha1 "e13ae1fdce4b0c89ef70f4695689139c8409e2e8"

  # Submitted upstream:
  # http://sourceforge.net/p/rssh/mailman/message/32251335/
  patch do
    url "https://gist.githubusercontent.com/arminsch/9230011/raw/f0c5ed95bbba0be28ce2b5f0d1080de84ec317ab/rsshconf-log-rename.diff"
    sha1 "7e49f539f307cd4c6eeaa0566961038dda6d721d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    # test to check if everything is linked correctly
    system "#{bin}/rssh", "-v"
    # the following test checks if rssh, if invoked without commands and options, fails
    system "sh", "-c", "! #{bin}/rssh"
  end
end
