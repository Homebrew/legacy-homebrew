class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/repository/archive.tar.gz?ref=v3.3.11"
  version "3.3.11"
  sha256 "69e421cb07d5dfd38100b4b68714e9cb05d4fe58a7c5145c7b672d1ff08ca58b"

  head "https://gitlab.com/procps-ng/procps.git"

  option "with-watch8bit", "Enable watch to be 8bit clean (requires ncurses)"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0d123fb9d979422d41d6c63dcea1b87732d354276b7bdecb4dc5a89c7390ca6" => :el_capitan
    sha1 "02dd29b9894a881d150ae369a0bd7e6c38517158" => :yosemite
    sha1 "4c879fbcd46a9867ec7a322ddbb466cb0a376825" => :mavericks
    sha1 "a7c559378bc74cd30d00f962e63d6ee5c705aea1" => :mountain_lion
  end

  depends_on "gettext" => :run
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "homebrew/dupes/ncurses" => :optional

  conflicts_with "visionmedia-watch"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking"]

    ENV.append "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
    ENV.append "CPPFLAGS", "-L#{Formula["gettext"].opt_include}"

    if build.with? "ncurses"
      ENV.append "LDFLAGS", "-L#{Formula["ncurses"].opt_lib}"
      ENV.append "CPPFLAGS", "-I#{Formula["ncurses"].opt_include}"

      # enabling it without installed ncurses will break the build
      args << "--enable-watch8bit" if build.with? "watch8bit"
    end

    inreplace "autogen.sh", /libtool/, "glibtool"

    system "./autogen.sh"
    system "./configure", *args

    # libtool breaks build if libintl isn't included strictly
    system "make", "watch", "LDADD=", "LIBS=-lintl"

    bin.mkpath
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    ENV["TERM"] = "xterm"
    system "#{bin}/watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
