require 'formula'

class MidnightCommander <Formula

  url 'http://www.midnight-commander.org/downloads/mc-4.7.5.tar.bz2'
  homepage 'http://www.midnight-commander.org/'
  sha256 '0d2b4e87b8a4158edf54380df9402b4a1a19f7494ef06dd0a0a3e3ff6a2b50f1'
  head 'git://midnight-commander.org/git/mc.git', :using => :git,
                                # Ok, it's not a HEAD, but it works
                                :tag => '69d66dd5984357e37a0742c5e4d97c9f9f6305eb'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 's-lang'

  def install
    if ARGV.build_head?
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      system 'mkdir m4'
      system 'cp `brew --prefix`/share/aclocal/pkg.m4 ./m4'
      system './autogen.sh'
      system "cd po; for i in `ls | grep '[.]po$' | cut -d'.' -f1 | xargs`; do ./update.sh $i; done; cd .."
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--with-screen=slang"
    system "make install"
  end
end
