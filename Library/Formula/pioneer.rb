require 'formula'

class Pioneer < Formula
  homepage 'http://pioneerspacesim.net/'
  url 'https://github.com/pioneerspacesim/pioneer/tarball/alpha20'
  sha1 '30004e8886533a7e95d14bf13e7188cd0e2f62a0'
  version 'alpha20'

  head 'https://github.com/pioneerspacesim/pioneer.git'

  depends_on 'pkg-config' => :build
  depends_on 'lame'
  depends_on 'libogg'
  depends_on 'flac'
  depends_on 'sdl'             # Requires version 1.2x, not SDL-HEAD.
  depends_on 'sdl_image'
  depends_on 'sdl_sound'       # You should build this --HEAD though (bugfixes).
  depends_on 'glew'
  depends_on 'libsigc++'

  if MacOS.xcode_version >= '4.3'
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def options
    [[ '--with-debug', 'Enable a debug build and disable optimization' ]]
  end

  def install
    # Remove ACLOCAL once automake is non-keg-only (the path will be builtin)
    ENV['ACLOCAL'] = "aclocal -I #{HOMEBREW_PREFIX}/share/aclocal"
    ENV.append 'LDFLAGS', '-L/System/Library/Frameworks/OpenGL.framework/Libraries'
    ENV.append 'LDFLAGS', '-L/System/Library/Frameworks/GLUT.framework'
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      PIONEER_DATA_DIR=#{prefix}/data
    ]
    if ARGV.include? '--with-debug' then
      args << '--enable-debug=yes'
      ENV.deparallelize
      ENV.remove_from_cflags '-w'
      if ENV.compiler == :clang
        ENV.Og
      else
        ENV.O2
        %w[ CFLAGS CXXFLAGS ].each { |v| ENV.append v, '-ggdb3' }
      end
    else
      args << '--enable-debug=no'
    end
    system "./bootstrap"
    system "./configure", *args
    system "make install"
    # Also copy the 11 MB src directory for debug and the instructions how to play.
    prefix.install %w[ src Quickstart.txt ]
  end

  def caveats
    <<-EOS.undent
      Pioneer is an OpenGL Space Simulator. You may have played an mmorpg like it.
      Once Pioneer is installed on your Mac, run it from the terminal using:
             pioneer
      and the game will start in an 800x600 window.  Choose:
             Start A New Game on Earth
      and you will be docked in Mexico City.  At that point you can hit ESC
      and change your screen resolution to the max, maybe 2560x1440 if you have
      an iMac.  There is a guide in
            #{prefix}/Quickstart.txt
      that tells you about the default keyboard controls for thrust and yaw,
      things you can also find out in the game using ESC --> Controls
      Note:  Saved games are not compatible between versions.  Delete
      your ~/Library/Application Support/Pioneer when you switch versions.
    EOS
  end
end
