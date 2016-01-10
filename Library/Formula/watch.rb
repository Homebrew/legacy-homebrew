class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://download.sourceforge.net/project/procps-ng/Production/procps-ng-3.3.10.tar.xz"
  sha256 "a02e6f98974dfceab79884df902ca3df30b0e9bad6d76aee0fb5dce17f267f04"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "96f5eb357252388cfe7051ffcec7c568681257e6965a58276ed53164b69e85cd" => :el_capitan
    sha256 "a8a2e64c291503ed386c06703a6a224b83d9d418dc28e7e118844707fdd1ef6f" => :yosemite
    sha256 "7240e4583b401d6931b75f35be341bd3805435409bf8ff1dee004b9a2db5534e" => :mavericks
  end

  conflicts_with "visionmedia-watch"

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
