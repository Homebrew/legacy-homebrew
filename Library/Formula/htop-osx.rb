require 'formula'

class HtopOsx < Formula
  homepage 'https://github.com/max-horvath/htop-osx'
  url 'https://github.com/max-horvath/htop-osx/archive/0.8.2.2.tar.gz'
  sha1 '17c56fe5efe81cf6b0f4c13a958fa7e4d8591b23'

  bottle do
    sha1 "1979feaa7dc6dc9ea8eba0eeba0903451b6dcb60" => :mavericks
    sha1 "60dfb6d300afd103aa5533b52302de3bb0dd067f" => :mountain_lion
    sha1 "ffed10bd7a4a6649120d8db66ac7b0daf686b982" => :lion
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
end
