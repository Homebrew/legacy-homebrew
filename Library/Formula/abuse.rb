require 'formula'

class Abuse < Formula
  url 'http://abuse.zoy.org/raw-attachment/wiki/download/abuse-0.8.tar.gz'
  homepage 'http://abuse.zoy.org/'
  head 'svn://svn.zoy.org/abuse/abuse/trunk'
  md5 'ec678b8dc8d00e0382d8c805c6438489'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'libvorbis'

  def startup_script; <<-EOS.undent
    #!/bin/sh

    #{libexec}/abuse-bin -datadir #{share}/abuse $*
    EOS
  end

  def install
    # Add SDL.m4 to aclocal includes
    inreplace 'bootstrap', 'aclocal${amvers} ${aclocalflags}',
      'aclocal${amvers} ${aclocalflags} -I/usr/local/share/aclocal'

    # undefined
    inreplace 'src/net/fileman.cpp', 'ushort', 'unsigned short'
    inreplace 'src/sdlport/setup.cpp', 'UInt8', 'uint8_t'

    # Re-enable OpenGL detection
    inreplace 'configure.ac',
      "#error\t/* Error so the compile fails on OSX */",
      '#include <OpenGL/gl.h>'

    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--with-assetdir=#{share}/abuse",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-sdl-prefix=#{HOMEBREW_PREFIX}"

    # Use Framework OpenGL, not libGl
    %w[ . src src/imlib src/lisp src/net src/sdlport ].each do |p|
      inreplace "#{p}/Makefile", '-lGL', '-framework OpenGL'
    end

    system "make"

    bin.install 'src/abuse-tool'
    libexec.install_p 'src/abuse', 'abuse-bin'
    (share+'abuse').install Dir["data/*"] - %w(data/Makefile data/Makefile.am data/Makefile.in)
    # Use a startup script to find the game data
    (bin+'abuse').write startup_script
  end

  def caveats; <<-EOS.undent
    Game settings and saves will be written to the ~/.abuse folder.
    EOS
  end

  def test
    system("#{libexec}/abuse-bin", '--help')
  end
end
