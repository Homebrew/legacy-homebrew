require 'formula'

class Valgrind <Formula
  homepage 'http://www.valgrind.org/'

  # 3.5.0 doesn't work well in Snow Leopard, or at all in 64-bit mode
  if MACOS_VERSION >= 10.6
    url "svn://svn.valgrind.org/valgrind/trunk", :revision => "11288"
    version '3.6-pre'
  else
    url 'http://www.valgrind.org/downloads/valgrind-3.5.0.tar.bz2'
    md5 'f03522a4687cf76c676c9494fcc0a517'
  end

  head "svn://svn.valgrind.org/valgrind/trunk"

  depends_on 'pkg-config'
  depends_on 'boost'

  def install
    system "./autogen.sh" if File.exists? "autogen.sh"

    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    if snow_leopard_64?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    end

    system "./configure", *args
    system "make install"
  end
end
