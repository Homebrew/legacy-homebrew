require 'formula'

class Cmus < Formula
  homepage 'http://cmus.sourceforge.net/'
  url 'http://downloads.sourceforge.net/cmus/cmus-v2.4.3.tar.bz2'
  sha1 'ba63a417b0df42fa9a4850dd8b922a95a426f7f5'

  head 'https://git.gitorious.org/cmus/cmus.git'

  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'mad'
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'faad2'
  depends_on 'flac'
  depends_on 'mp4v2'
  depends_on 'libcue' if build.head?

  skip_clean 'bin/cmus'
  skip_clean 'bin/cmus-remote'

  def install
    # We add this to CPPFLAGS and LDFLAGS in ENV, but cmus doesn't
    # pick up on that. Adding this patch because I am too lazy to
    # send a patch upstream to respect CPPFLAGS - @adamv
    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      ENV.append 'CFLAGS', "-isystem #{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make install"
  end
end
