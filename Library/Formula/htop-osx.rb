class HtopOsx < Formula
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.3.tar.gz"
  sha1 "43d63772dd610fb238e3b9a83c066658bd6218d9"

  bottle do
    revision 1
    sha1 "846c2f8b7711960139af43f407d23f058825ca8f" => :yosemite
    sha1 "3c6b4366aae7b1dad12275a66c4fa68e2c0312b7" => :mavericks
    sha1 "3736ab4a1ac5cc0c3593e882a51d65a99ed359f0" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Otherwise htop will segfault when resizing the terminal
    ENV.no_optimization if ENV.compiler == :clang

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install", "DEFAULT_INCLUDES='-iquote .'"
  end

  def caveats; <<-EOS.undent
    htop-osx requires root privileges to correctly display all running processes.
    You can either run the program via `sudo` or set the setuid bit:

      sudo chown root:wheel #{bin}/htop
      sudo chmod u+s #{bin}/htop

    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    pipe_output("#{bin}/htop", "q")
    assert $?.success?
  end
end
