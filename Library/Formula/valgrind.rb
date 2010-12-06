require 'formula'

class Valgrind <Formula
  homepage 'http://www.valgrind.org/'

  url "http://valgrind.org/downloads/valgrind-3.6.0.tar.bz2"
  md5 "b289c5f4ab8e39741602445f1dd09b34"

  depends_on 'pkg-config' => :build

  skip_clean 'lib'

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
