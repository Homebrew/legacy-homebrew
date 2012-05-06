require 'formula'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'

  # Valgrind 3.7.0 drops support for OS X 10.5
  if MACOS_VERSION >= 10.6
    url 'http://valgrind.org/downloads/valgrind-3.7.0.tar.bz2'
    md5 'a855fda56edf05614f099dca316d1775'
  else
    url "http://valgrind.org/downloads/valgrind-3.6.1.tar.bz2"
    md5 "2c3aa122498baecc9d69194057ca88f5"
  end

  skip_clean 'lib'

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    if MacOS.prefer_64_bit?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    else
      args << "--enable-only32bit"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/valgrind ls -l"
  end
end
