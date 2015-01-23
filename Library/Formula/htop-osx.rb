class HtopOsx < Formula
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.3.tar.gz"
  sha1 "43d63772dd610fb238e3b9a83c066658bd6218d9"

  bottle do
    sha1 "9de4bee7456fe78f5569bac225cd9d23af1b72eb" => :yosemite
    sha1 "30d4a704b72f2b05b95375c7308f67ea8b5ce272" => :mavericks
    sha1 "a795b939866e1d130bf93762e4b8d755249c634e" => :mountain_lion
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
