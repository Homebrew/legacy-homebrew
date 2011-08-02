require 'formula'

class Haproxy < Formula
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.15.tar.gz'
  md5 'c1b4fc6028c6d8e23dde8c91ff47eabe'
  homepage 'http://haproxy.1wt.eu'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! 'PREFIX', prefix
      s.change_make_var! 'DOCDIR', doc
      # use our CC, CFLAGS and LDFLAGS
      s.remove_make_var! %w[LDFLAGS CFLAGS CC]
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "TARGET=generic USE_KQUEUE=1 USE_POLL=1 USE_PCRE=1"
    system "make install"
  end
end
