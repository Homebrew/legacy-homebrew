require 'formula'

class Luajit < Formula
  homepage 'http://luajit.org/luajit.html'
  url 'http://luajit.org/download/LuaJIT-2.0.0-beta10.tar.gz'
  sha1 '560d06621ea616bea1d67867faa235d608040396'

  head 'http://luajit.org/git/luajit-2.0.git'

  # Skip cleaning both empty folders and bin/libs so external symbols still work.
  skip_clean :all

  def options
    [["--enable-debug", "Build with debugging symbols."]]
  end

  def install
    # 1 - Remove the '-O2' so we can set Og if needed.  Leave the -fomit part.
    # 2 - Override the hardcoded gcc.
    # 3 - Remove the '-march=i686' so we can set the march in cflags.
    # All three changes should persist and were discussed upstream.
    inreplace 'src/Makefile' do |f|
      f.change_make_var! 'CCOPT', '-fomit-frame-pointer'
      f.change_make_var! 'CC', ENV.cc
      f.change_make_var! 'CCOPT_X86', ''
    end

    ENV.O2                          # Respect the developer's choice.
    args = [ "PREFIX=#{prefix}" ]
    if ARGV.include? '--enable-debug' then
      ENV.Og if ENV.compiler == :clang
      args << 'CCDEBUG=-g'
    end

    bldargs = args
    bldargs << 'amalg'
    system 'make', *bldargs
    args << 'install'
    system 'make', *args            # Build requires args during install

    # Non-versioned symlink
    if ARGV.build_head?
      version = "2.0.0-beta10"
    else
      version = @version
    end
    ln_s bin+"luajit-#{version}", bin+"luajit"
  end
end
