class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://github.com/hishamhm/htop"
  url "https://github.com/hishamhm/htop/archive/2.0.0.tar.gz"
  sha256 "2522a93792dfee188bfaff23f30332d1173460c95f9869588398e9bdd3a0491b"

  bottle do
    sha256 "ea2e857053d895bced97279bbd5043223f4d17a57e16cac606132bb649397f09" => :el_capitan
    sha256 "7b63b2a65dad23be546e4f3a1518c533243e4fe0080c8107107cceef344b70a7" => :yosemite
    sha256 "9518a50b960bb36910c0df40a68f91261578dad53fbaff34f694b93150abf2be" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "htop-osx", :because => "both install an `htop` binary"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    htop requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    pipe_output("#{bin}/htop", "q", 0)
  end
end
