class Htop < Formula
  desc "Improved top (interactive process viewer) for OS X"
  homepage "http://hisham.hm/htop/"
  url "https://github.com/hishamhm/htop/archive/2.0.0.tar.gz"
  sha256 "2522a93792dfee188bfaff23f30332d1173460c95f9869588398e9bdd3a0491b"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    htop requires root privileges to correctly display all running processes.
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    pipe_output("#{bin}/htop", "q")
    assert $?.success?
  end
end
