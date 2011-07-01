require 'formula'

class NetNuclearSoundsAndGraphics < Formula
  # Source tarball doesn't include sfx or gfx.
  # Get them from a v4 binary build.
  url 'http://studiostok.se/files/netnuclear4-linux.tar.gz'
  version '4'
  md5 '2dbbfe9083275aa170cb96d48237cfe4'
end


class NetNuclear < Formula
  url 'http://studiostok.se/files/netnuclear4-source.rar'
  version '4'
  homepage 'http://studiostok.se/?page=netnuclear'
  md5 '061df954d0632f1cbc158dc0002e4b6c'

  depends_on 'sdl'
  depends_on 'sdl_mixer'
  depends_on 'sdl_net'

  def startup_script
      return <<-END
#!/bin/bash
#{libexec}/nuclear $*
END
  end

  def install
    inreplace 'Makefile' do |s|
      s.remove_make_var! 'CC'
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} -I#{HOMEBREW_PREFIX}/include/SDL"
      s.change_make_var! 'LIBS', "-lSDLmain -lSDL -lSDL_mixer -lSDL_net -framework Cocoa"
    end

    system 'make'
    libexec.install 'nuclear'

    d = libexec
    NetNuclearSoundsAndGraphics.new.brew { d.install ['sfx','gfx'] }

    (bin+'nuclear').write startup_script
  end
end
