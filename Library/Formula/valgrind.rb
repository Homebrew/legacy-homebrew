require 'formula'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'

  # Valgrind 3.7.0 drops support for OS X 10.5
  if MacOS.version >= 10.6
    url 'http://valgrind.org/downloads/valgrind-3.8.0.tar.bz2'
    sha1 '074b09e99b09634f1efa6f7f0f87c7a541fb9b0d'
  else
    url "http://valgrind.org/downloads/valgrind-3.6.1.tar.bz2"
    md5 "2c3aa122498baecc9d69194057ca88f5"
  end

  head 'svn://svn.valgrind.org/valgrind/trunk'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  skip_clean 'lib'

  def install
    # avoid __bzero when building against OS X 10.8 sdk
    if MacOS.version >= 10.8
      ENV.remove_from_cflags "-mmacosx-version-min=#{MacOS.version}"
    end

    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    if MacOS.prefer_64_bit?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    else
      args << "--enable-only32bit"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/valgrind", "ls", "-l"
  end
end
