require 'formula'

class Autoconf267 <Formula
  url 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.67.tar.bz2'
  md5 '3fbf92eb8eaca1e0d33dff9710edb5f0'
  homepage 'http://www.gnu.org/software/autoconf/'
end

class Valgrind <Formula
  homepage 'http://www.valgrind.org/'

  # Stable release doesn't work in 64-bit mode
  if MACOS_VERSION == 10.5
    url 'http://www.valgrind.org/downloads/valgrind-3.5.0.tar.bz2'
    md5 'f03522a4687cf76c676c9494fcc0a517'
  end

  head "svn://svn.valgrind.org/valgrind/trunk", :revision => "11255"

  depends_on 'pkg-config'
  depends_on 'boost'

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]

    if MACOS_VERSION >= 10.6
      # OS X comes with 2.61, which is too old
      ac_prefix = Pathname.pwd+'ac267'
      Autoconf267.new.brew do |f|
        system "./configure", "--prefix=#{ac_prefix}"
        system "make install"
      end

      ENV.prepend "PATH", ac_prefix+'bin', ":"

      system "./autogen.sh" if File.exists? "autogen.sh"
      args << "--enable-only64bit" << "--build=amd64-darwin"
    end

    system "./configure", *args
    system "make install"
  end
end
