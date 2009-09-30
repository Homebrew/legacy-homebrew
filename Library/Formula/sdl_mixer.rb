require 'brewkit'

class SdlMixer <Formula
  url 'http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.8.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_mixer/'
  md5 '0b5b91015d0f3bd9597e094ba67c4d65'

  depends_on 'sdl'
  
  def patches
    # http://www.libsdl.org/cgi/viewvc.cgi/trunk/SDL_mixer/configure.in?r1=4868&r2=4867&pathrev=4868
    DATA
  end

  def install
    ENV.gcc_4_2
    # We use a private include folder, and then
    # symlink the header file ourselves.
    # See: http://github.com/mxcl/homebrew/issues#issue/62
    system "./configure", "--prefix=#{prefix}",
                          "--includedir=#{prefix}/priv_include",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          # http://trac.macports.org/changeset/58317
                          "--disable-music-native-midi"
    system "make install"

    # Hack alert:
    # Since SDL is installed as a dependency, we know it exists, so we
    # symlink our new header file into its brewed location.
    FileUtils.ln_s "#{prefix}/priv_include/SDL/SDL_mixer.h", "#{HOMEBREW_PREFIX}/include/SDL"
  end
end


__END__
--- a/configure.in	2009/09/27 19:23:04	4867
+++ b/configure.in	2009/09/27 19:34:09	4868
@@ -221,8 +221,10 @@
                 EXTRA_LDFLAGS="$EXTRA_LDFLAGS -lwinmm"
                 ;;
             *-*-darwin*)
-                use_music_native_midi=yes
-                EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-framework,QuickTime -Wl,-framework,CoreServices"
+                # This doesn't work on Mac OS X 10.5+
+                # Max Horn (the original author) recommends disabling it for now.
+                #use_music_native_midi=yes
+                #EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-framework,QuickTime -Wl,-framework,CoreServices"
                 ;;
         esac
         if test x$use_music_native_midi = xyes; then
