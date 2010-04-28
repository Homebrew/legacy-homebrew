require 'formula'

class Haproxy <Formula
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.4.tar.gz'
  md5 '0a18b915c3039f37004a346a5ddc17cd'
  homepage 'http://haproxy.1wt.eu'

  def install
    inreplace 'Makefile' do |contents|
      contents.change_make_var! 'PREFIX', prefix
      contents.change_make_var! 'DOCDIR', doc
      # use our CC, CFLAGS and LDFLAGS
      contents.remove_make_var! %w[LDFLAGS CFLAGS CC]
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "TARGET=generic USE_KQUEUE=1 USE_POLL=1 USE_PCRE=1"
    system "make install"
  end
end
