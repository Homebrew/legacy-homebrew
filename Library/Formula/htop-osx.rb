class HtopOsx < Formula
  desc "Improved top (interactive process viewer) for OS X"
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.7.tar.gz"
  sha256 "a93be5c9d8a68081590b1646a0f10fb90e966e306560c3b141a61b3849446b72"

  bottle do
    sha256 "d0b96a00a44bdc3ee68bc6e54637a98e578a798915be049a53da3a0c47c1e2ec" => :yosemite
    sha256 "bb70c1dbd415929263c358288cc21489cdb45f9e18d9d3d9d51ffbe14e0ea6ef" => :mavericks
    sha256 "b607461d74d89fdd9b9b7835f3c2311cfcfe1ddd16826260bbe089d80c40d60b" => :mountain_lion
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
