require 'formula'

class Tracebox < Formula
  homepage 'http://www.tracebox.org/'
  url 'https://drone.io/github.com/tracebox/tracebox/files/tracebox-0.1.tar.gz'
  sha1 '4656b0a6660e2a9833ff8f541d6d88034d011e7b'

  depends_on 'lua'

  def install
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
