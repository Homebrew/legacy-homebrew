class HtopOsx < Formula
  desc "Improved top (interactive process viewer) for OS X"
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.5.tar.gz"
  sha1 "53b05ba70658ee1372588797438896b5fd5aa570"

  bottle do
    sha256 "6799da108aa993d1cbc5a7f638c3529cbf16e53a7b5622694df601c0d7eac085" => :yosemite
    sha256 "e0ed38e75cd7953fcbb66b20c2fabb673a087eae04cfa0bac64fcfe85b442262" => :mavericks
    sha256 "503c8385134741cc7f3974c5097d3bef4227e1717b26a1a745fd768c31fb5f6f" => :mountain_lion
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
