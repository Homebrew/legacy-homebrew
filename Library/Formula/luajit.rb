require 'formula'

class Luajit < Formula
  homepage 'http://luajit.org/luajit.html'
  url 'http://luajit.org/download/LuaJIT-2.0.2.tar.gz'
  sha1 'd21426c4fc6ad8888255139039a014f7e28e7300'
  head 'http://luajit.org/git/luajit-2.0.git'

  skip_clean 'lib/lua/5.1', 'share/lua/5.1'

  option "enable-debug", "Build with debugging symbols"

  def install
    # 1 - Remove the '-O2' so we can set Og if needed.  Leave the -fomit part.
    # 2 - Override the hardcoded gcc.
    # 3 - Remove the '-march=i686' so we can set the march in cflags.
    # All three changes should persist and were discussed upstream.
    inreplace 'src/Makefile' do |f|
      f.change_make_var! 'CCOPT', '-fomit-frame-pointer'
      f.change_make_var! 'CC', ENV.cc
      f.change_make_var! 'CCOPT_x86', ''
    end

    ENV.O2                          # Respect the developer's choice.
    args = ["PREFIX=#{prefix}"]
    if build.include? 'enable-debug' then
      ENV.Og if ENV.compiler == :clang
      args << 'CCDEBUG=-g'
    end

    bldargs = args
    bldargs << 'amalg'
    system 'make', *bldargs
    args << 'install'
    system 'make', *args            # Build requires args during install
  end
end
