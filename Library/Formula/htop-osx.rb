class HtopOsx < Formula
  desc "Improved top (interactive process viewer) for OS X"
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.8.tar.gz"
  sha256 "3d8614a3be5f5ba76a96b22c14a456dc66242c5ef1ef8660a60bb6b766543458"

  bottle do
    revision 1
    sha256 "9eea952eb4849a3c7e60772df5701b826e9b7cb2751dfe5d434baf83bad56b0d" => :el_capitan
    sha256 "d0e2cc8d452bde53d949a6d498346678b7b00c6d9c61471cd0a33e6dcbbe5399" => :yosemite
    sha256 "355a26860f7eb39a10915a15ccc9e84593d29f63137562910302c497df447963" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "htop", :because => "both install an `htop` binary"

  def install
    # Otherwise htop will segfault when resizing the terminal
    ENV.no_optimization if ENV.compiler == :clang

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install", "DEFAULT_INCLUDES='-iquote .'"
  end

  def caveats; <<-EOS.undent
    htop-osx requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    pipe_output("#{bin}/htop", "q", 0)
  end
end
