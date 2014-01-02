require 'formula'

class Luajit < Formula
  homepage 'http://luajit.org/luajit.html'
  url 'http://luajit.org/download/LuaJIT-2.0.2.tar.gz'
  sha1 'd21426c4fc6ad8888255139039a014f7e28e7300'
  head 'http://luajit.org/git/luajit-2.0.git'

  skip_clean 'lib/lua/5.1', 'share/lua/5.1'

  option "enable-debug", "Build with debugging symbols"

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the '-march=i686' so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace 'src/Makefile' do |f|
      f.change_make_var! 'CC', ENV.cc
      f.change_make_var! 'CCOPT_x86', ''
    end

    ENV.O2 # Respect the developer's choice.

    args = %W[PREFIX=#{prefix}]

    # This doesn't yet work under superenv because it removes '-g'
    args << 'CCDEBUG=-g' if build.include? 'enable-debug'

    system 'make', 'amalg', *args
    system 'make', 'install', *args
  end

  test do
    system "#{bin}/luajit", "-e", <<-EOS.strip
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV['USER']}")
      EOS
  end
end
