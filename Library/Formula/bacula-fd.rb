class BaculaFd < Formula
  desc "Network backup solution"
  homepage "http://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/7.0.5/bacula-7.0.5.tar.gz"
  sha256 "1457849eb33011b43371801b62ffa13d29bebe51be8d5a36da563b87bb094a49"

  bottle do
    sha256 "be21d52d33740a962ec21852785107917a5e1296053d98552f16b8c73c8fcd4a" => :yosemite
    sha256 "b2d914bedd7827de1ad3dd10ae627ad85fdbe3cbea383f5c6832ad0ce82b7a08" => :mavericks
    sha256 "c96f1a160cf35a85d58734065ab50578937361f4f4f29468b145348a94a27cf1" => :mountain_lion
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    # * sets --disable-conio in order to force the use of readline
    #   (conio support not tested)
    # * working directory in /var/lib/bacula, reasonable place that
    #   matches Debian's location.
    readline = Formula["readline"].opt_prefix
    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--with-working-dir=#{var}/lib/bacula",
                          "--with-pid-dir=#{HOMEBREW_PREFIX}/var/run",
                          "--enable-client-only",
                          "--disable-conio",
                          "--with-readline=#{readline}"

    system "make"
    system "make", "install"

    # Ensure var/run exists:
    (var + "run").mkpath

    # Create the working directory:
    (var + "lib/bacula").mkpath
  end
end
