require "formula"

class Emacs23Installed < Requirement
  fatal true
  env :userpaths
  default_formula "emacs"

  satisfy do
    `emacs --version 2>/dev/null` =~ /^GNU Emacs (\d{2})/
    $1.to_i >= 23
  end
end

class Mu < Formula
  homepage "http://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/archive/v0.9.11.tar.gz"
  sha1 "080b69bfb4876cb683acb961e8b71d6ebba90fa0"

  head "https://github.com/djcb/mu.git"

  bottle do
    sha1 "b9e3a478300b3391f6a38639e32694f5444bea2d" => :yosemite
    sha1 "61b8eadfbfa482de3d1194c5cb8bc5a3cb0933d6" => :mavericks
    sha1 "ef81baa0a3210ba9c4a7eeb9224574e1cc89e5d8" => :mountain_lion
  end

  option "with-emacs", "Build with emacs support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "xapian"
  depends_on Emacs23Installed if build.with? "emacs"

  env :std if build.with? "emacs"

  def install
    # Explicitly tell the build not to include emacs support as the version
    # shipped by default with Mac OS X is too old.
    ENV["EMACS"] = "no" if build.without? "emacs"

    # I dunno.
    # https://github.com/djcb/mu/issues/332
    # https://github.com/Homebrew/homebrew/issues/25524
    ENV.delete "MACOSX_DEPLOYMENT_TARGET"

    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gui=none"
    system "make"
    system "make test"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Existing mu users are recommended to run the following after upgrading:

      mu index --rebuild
    EOS
  end
end
