require 'formula'

class Haproxy <Formula
  url 'http://haproxy.1wt.eu/download/1.3/src/haproxy-1.3.22.tar.gz'
  md5 'b84e0935cfea99eda43645d53bb82367'
  homepage 'http://haproxy.1wt.eu'

  def install
    inreplace 'Makefile', 'PREFIX = /usr/local', "PREFIX = #{prefix}"
    inreplace 'Makefile', 'DOCDIR = $(PREFIX)/doc/haproxy', "DOCDIR = #{doc}"
    # use our CC, LD, CFLAGS and LDFLAGS
    inreplace 'Makefile', 'LDFLAGS = $(ARCH_FLAGS) -g', ''
    inreplace 'Makefile', 'CFLAGS = $(ARCH_FLAGS) $(CPU_CFLAGS) $(DEBUG_CFLAGS)', ''
    inreplace 'Makefile', 'CC = gcc', ''
    inreplace 'Makefile', 'LD = $(CC)', ''

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "TARGET=generic"
    system "make install"
  end
end
