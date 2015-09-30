class HtopOsx < Formula
  desc "Improved top (interactive process viewer) for OS X"
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.7.tar.gz"
  sha256 "a93be5c9d8a68081590b1646a0f10fb90e966e306560c3b141a61b3849446b72"

  bottle do
    sha256 "d127accb5266fc5522cecc6e93a6039b978a7abbd6be9765b9991b72602a3459" => :el_capitan
    sha256 "c4f4c2be9f6bda38bef8e57570cb02ec2a60738b5e3e6b27c189e493582daf66" => :yosemite
    sha256 "1e3fa7862bfcef0eed646b7c2b7f1d3ec491404b2c9312ae1045bb78b8059f30" => :mavericks
    sha256 "611c4ee686babb880828510fd3b1cfa247aa1e0ba6cb60401e8ad5c6cac1fc75" => :mountain_lion
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
