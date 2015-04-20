require 'formula'

class Watch < Formula
  homepage 'http://sourceforge.net/projects/procps-ng/'
  url 'http://download.sourceforge.net/project/procps-ng/Production/procps-ng-3.3.10.tar.xz'
  sha1 '484db198d6a18a42b4011d5ecb2cb784a81b0e4f'

  bottle do
    cellar :any
    sha1 "02dd29b9894a881d150ae369a0bd7e6c38517158" => :yosemite
    sha1 "4c879fbcd46a9867ec7a322ddbb466cb0a376825" => :mavericks
    sha1 "a7c559378bc74cd30d00f962e63d6ee5c705aea1" => :mountain_lion
  end

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
