require 'formula'

class Wmiixixp <Formula
  url 'http://dl.suckless.org/wmii/wmii+ixp-3.9.2.tbz'
  homepage 'http://wmii.suckless.org/'
  md5 '3d480502b7b1e2a405d941df67f16bcf'

  # depends_on 'cmake'

  def install
    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
    #                      "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end
end

# This will fail to build on OSX. Here's a patch. Needs to be included 
# in this formula...
#
#
#
# diff wmii+ixp-3.9.2-original/config.mk wmii+ixp-3.9.2-patched/config.mk
# 14c14
# < LIBS = -L$(ROOT)/lib -L/usr/lib
# ---
# > LIBS = -L$(ROOT)/lib -L/usr/lib -L/usr/X11/lib -lX11
# 20,21c20,21
# < CFLAGS += -Os # $(DEBUGCFLAGS) -O0
# < LDFLAGS += # -g $(LIBS)
# ---
# > CFLAGS += -Os $(DEBUGCFLAGS) -O0 -D_DARWIN_C_SOURCE -std=c99
# > LDFLAGS += -g $(LIBS)
# 55,57c55,57
# < #STATIC = # Darwin doesn't like static linking
# < #SHARED = -dynamiclib
# < #SOEXT = dylib
# ---
# > STATIC = # Darwin doesn't like static linking
# > SHARED = -dynamiclib
# > SOEXT = dylib
