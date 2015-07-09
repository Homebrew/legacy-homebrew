class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.mit.edu/"
  url "https://mosh.mit.edu/mosh-1.2.4.tar.gz"
  sha256 "e74d0d323226046e402dd469a176075fc2013b69b0e67cea49762c957175df46"
  revision 2

  bottle do
    sha256 "3c108593641fb31bf079147e66d15c711745604ceb395005c57abe4e57b844ad" => :yosemite
    sha256 "d5527371143c95e39a4535e70be7cbc5c659b2b95d5dd609b766cdc20ca038b2" => :mavericks
    sha256 "4d480c213adba08197a671939466accbf9019365895f01452278a51345b168c0" => :mountain_lion
  end

  devel do
    url "https://github.com/keithw/mosh/archive/mosh-1.2.4.95rc2.tar.gz"
    sha256 "56571fb1cb9c9714013ab0fc813863d58e0f5c7d320430aa05df952295e046a7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  head do
    url "https://github.com/keithw/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-check", "Run build-time tests"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "protobuf"

  def install
    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    # This has landed in devel and head.
    if build.stable?
      inreplace "scripts/mosh", "'mosh-client", "\'#{bin}/mosh-client"
    else
      system "./autogen.sh"
      inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"
    end

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("check") || build.bottle?
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system "#{bin}/mosh-client", "-c"
  end
end
