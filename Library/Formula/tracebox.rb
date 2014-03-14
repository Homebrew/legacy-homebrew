require 'formula'

class Tracebox < Formula
  homepage 'http://www.tracebox.org/'
  head 'https://github.com/tracebox/tracebox.git'
  url 'https://github.com/tracebox/tracebox.git', :tag => 'v0.2'

  depends_on 'lua'
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    ENV.append "AUTOHEADER", "true"
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    tracebox requires superuser privileges. You can either run the program
    via `sudo`, or change its ownership to root and set the setuid bit:

      sudo chown root:wheel #{bin}/tracebox
      sudo chmod u+s #{bin}/tracebox

    In any case, you should be certain that you trust the software you
    are executing with elevated privileges.
    EOS
  end
end
