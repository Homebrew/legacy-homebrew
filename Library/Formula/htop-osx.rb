require 'formula'

class HtopOsx < Formula
  homepage 'https://github.com/max-horvath/htop-osx'
  url 'https://github.com/max-horvath/htop-osx/archive/0.8.2.1-2012-04-18.tar.gz'
  sha1 '4f8cddb22aa398652a14cbe3168be9aeeecfff33'
  version '0.8.2.1'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    # Otherwise htop will segfault when resizing the terminal
    ENV.no_optimization if ENV.compiler == :clang

    (buildpath/'m4').mkpath # or autogen fails
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
