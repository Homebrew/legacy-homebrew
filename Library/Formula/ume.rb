require 'formula'

class Ume < Formula
  homepage 'http://mamedev.org/'
  url 'svn://dspnet.fr/mame/trunk', :revision => '26743'
  version '0.152'

  head 'svn://dspnet.fr/mame/trunk'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = "-I#{MacOS::X11.include}"
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    # Avoid memory allocation runtime error:
    #   Error: attempt to free untracked memory in (null)(0)!
    #   Ignoring MAME exception: Error: attempt to free untracked memory
    ENV.O2 if ENV.compiler == :clang

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "TARGET=ume"

    if MacOS.prefer_64_bit?
      bin.install 'ume64' => 'ume'
    else
      bin.install 'ume'
    end
  end
end
