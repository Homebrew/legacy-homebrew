require 'formula'

class Babl < Formula
  homepage 'http://www.gegl.org/babl/'
  url 'ftp://ftp.gtk.org/pub/babl/0.1/babl-0.1.10.tar.bz2'
  md5 '9e1542ab5c0b12ea3af076a9a2f02d79'

  head 'git://git.gnome.org/babl'

  depends_on 'pkg-config' => :build

  def options
    [["--universal", "Builds a universal binary"]]
  end

  def patches
    # There are two patches.
    # The first one changes an include <values.h> (deleted on Mac OS X) to <limits.h>
    # The second one fixes an error when compiling with clang. See:
    # https://trac.macports.org/browser/trunk/dports/graphics/babl/files/clang.patch
    { :p0 => DATA }
  end

  def install
    if ARGV.build_universal?
      ENV.universal_binary
      if ENV.compiler == :gcc
        opoo 'Compilation may fail at babl-cpuaccel.c using gcc for a universal build'
      end
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff -cr babl.ori/babl-palette.c babl/babl-palette.c
*** babl.ori/babl-palette.c	Sat Apr 14 01:31:40 2012
--- babl/babl-palette.c	Sat Apr 14 01:32:15 2012
***************
*** 19,25 ****
  #include <stdlib.h>
  #include <string.h>
  #include <stdio.h>
! #include <values.h>
  #include <assert.h>
  #include "config.h"
  #include "babl-internal.h"
--- 19,25 ----
  #include <stdlib.h>
  #include <string.h>
  #include <stdio.h>
! #include <limits.h>
  #include <assert.h>
  #include "config.h"
  #include "babl-internal.h"
diff -cr extensions.ori/sse-fixups.c extensions/sse-fixups.c
*** extensions.ori/sse-fixups.c	Sat Apr 14 01:31:40 2012
--- extensions/sse-fixups.c	Sat Apr 14 01:33:44 2012
***************
*** 21,27 ****
  
  #include "config.h"
  
! #if defined(__GNUC__) && (__GNUC__ >= 4) && defined(USE_SSE) && defined(USE_MMX)
  
  #include <stdint.h>
  #include <stdlib.h>
--- 21,27 ----
  
  #include "config.h"
  
! #if !defined(__clang__) && defined(__GNUC__) && (__GNUC__ >= 4) && defined(USE_SSE) && defined(USE_MMX)
  
  #include <stdint.h>
  #include <stdlib.h>
***************
*** 177,183 ****
  int
  init (void)
  {
! #if defined(__GNUC__) && (__GNUC__ >= 4) && defined(USE_SSE) && defined(USE_MMX)
  
    const Babl *rgbaF_linear = babl_format_new (
      babl_model ("RGBA"),
--- 177,183 ----
  int
  init (void)
  {
! #if !defined(__clang__) && defined(__GNUC__) && (__GNUC__ >= 4) && defined(USE_SSE) && defined(USE_MMX)
  
    const Babl *rgbaF_linear = babl_format_new (
      babl_model ("RGBA"),
