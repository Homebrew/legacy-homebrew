class HtopOsx < Formula
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.4.tar.gz"
  sha1 "d6a2556295fdc129d1781fe1ae9ff0d517da4b2e"

  bottle do
    sha1 "4f393cee022d94fa1a4382efd639aabd6a493845" => :yosemite
    sha1 "ecb0715eff99b2d2ee4ff70f03edfda80e917221" => :mavericks
    sha1 "7bdb5b371a92a6190e2040a113f5c7f30f8429e9" => :mountain_lion
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
