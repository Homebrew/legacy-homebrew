require 'formula'

class HtopOsx < Formula
  homepage 'https://github.com/max-horvath/htop-osx'
  version '0.8.2.1'
  url 'https://github.com/max-horvath/htop-osx/tarball/0.8.2.1-2012-04-18'
  sha1 '90975472c683e59a6476e215ae5cb768d86659a8'

  binname = 'htop'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  if build.include? 'env=super'
     onoe "#{binname} crashes in procedure BarMeterMode_draw (Meter.c) if using super environment"
     exit 1
  end

  env :std
  ohai 'compiling using standard environment...'

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
