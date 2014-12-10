require 'formula'

class Watch < Formula
  homepage 'http://sourceforge.net/projects/procps-ng/'
  url 'http://download.sourceforge.net/project/procps-ng/Production/procps-ng-3.3.10.tar.xz'
  sha1 '484db198d6a18a42b4011d5ecb2cb784a81b0e4f'

  conflicts_with 'visionmedia-watch'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"

    # AM_LDFLAGS contains a non-existing library './proc/libprocps.la' that
    # breaks the linking process. Upstream developers have been informed (see 
    # https://github.com/Homebrew/homebrew/pull/34852/files#r21796727).
    system "make", "watch", "AM_LDFLAGS="
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    ENV["TERM"] = "xterm"
    system "#{bin}/watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
