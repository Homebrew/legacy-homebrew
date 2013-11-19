require 'formula'

class Tracebox < Formula
  homepage 'http://www.tracebox.org/'
  url 'https://github.com/tracebox/tracebox/archive/v0.1.tar.gz'
  sha1 'f41917b76d38bb2e7fd264516948166270758e2a'

  depends_on 'git' => :build
  depends_on 'lua'
  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on :libtool => :build

  def install
    ENV['AUTOHEADER'] = 'true'
    system "mkdir -p m4"
    system "git clone https://github.com/bhesmans/click.git tests/tools/click"
    system "git clone https://github.com/gdetal/libcrafter.git noinst/libcrafter"
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "tracebox"
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
