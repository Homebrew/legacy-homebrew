require 'brewkit'

class Wine <Formula
  url 'http://ibiblio.org/pub/linux/system/emulators/wine/wine-1.1.30.tar.bz2'
  md5 '3b78497f71cf6f112bac6de74e5cb29f'
  homepage 'http://www.winehq.org/'
  
  depends_on 'jpeg'
  #depends_on 'mpg123' => optional # doesn't yet compile on 10.6

  def install
    ENV.gcc_4_2 # TODO: add a comment explaining why we do this
    ENV.x11

    # Make sure we build 32bit version # TODO: add a comment explaining why we do this
    build32 = "-arch i386 -m32"

    ENV["LIBS"] = "-lGL -lGLU"
    ENV["CFLAGS"] = [ENV["CFLAGS"], build32].join(' ')
    ENV["CXXFLAGS"] = [ENV["CFLAGS"], "-D_DARWIN_NO_64_BIT_INODE"].join(' ')
    ENV["LDFLAGS"] = [ENV["LDFLAGS"], build32, "-framework CoreServices", "-lz", "-lGL -lGLU"].join(' ')
    ENV["DYLD_FALLBACK_LIBRARY_PATH"] = [ENV["DYLD_FALLBACK_LIBRARY_PATH"], "/usr/X11/lib"].join(' ')

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-win16"
    system "make install"
    rename_binary
    install_wrapper
  end

  def caveats; <<-EOS
Get winetricks with:
    wget http://www.kegel.com/wine/winetricks > #{prefix}/bin/winetricks
    chmod +x #{prefix}/bin/winetricks
    brew link wine
    EOS
  end

  def wine_wrapper
    DATA
  end
  
  def rename_binary
    (bin+'wine').rename(bin+'wine.bin')
  end

  def install_wrapper
    (bin+'wine').write(wine_wrapper.read.gsub('@PREFIX@', prefix))
  end
end

__END__
#!/bin/sh
DYLD_FALLBACK_LIBRARY_PATH="/usr/X11/lib" \
"@PREFIX@/bin/wine.bin" "$@"
