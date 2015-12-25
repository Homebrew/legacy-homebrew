class HtopOsx < Formula
  desc "Improved top (interactive process viewer) for OS X"
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.8.tar.gz"
  sha256 "3d8614a3be5f5ba76a96b22c14a456dc66242c5ef1ef8660a60bb6b766543458"

  bottle do
    sha256 "cbb0df837038f53f489d00cb89ed676463e341a9f1520735137f42a5bbd3c799" => :el_capitan
    sha256 "3e2c9c3bbbd360e1418e516cf06df2989289fa4a4d36616b7357af21d4943f36" => :yosemite
    sha256 "d205c9e82989e05bcbfca10c0aa2fea7c44a9468bb130b30437236589781e222" => :mavericks
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
