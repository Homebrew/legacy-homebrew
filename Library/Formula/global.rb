require 'formula'

class Global < Formula
  homepage 'http://www.gnu.org/software/global/'
  url 'http://ftpmirror.gnu.org/global/global-6.2.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.2.11.tar.gz'
  sha1 'b0f50213680ec3288988354c34e3b3ae1a42719e'

  head do
    url 'cvs://:pserver:anonymous:@cvs.savannah.gnu.org:/sources/global:global'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'with-exuberant-ctags', 'Enable Exuberant Ctags as a plug-in parser'

  if build.with? 'exuberant-ctags'
    depends_on 'ctags'
    skip_clean 'lib/gtags/exuberant-ctags.la'
  end

  def install
    system "sh", "reconf.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    if build.with? 'exuberant-ctags'
      args << "--with-exuberant-ctags=#{HOMEBREW_PREFIX}/bin/ctags"
    end

    system "./configure", *args
    system "make install"

    etc.install 'gtags.conf'

    # we copy these in already
    cd share/'gtags' do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end
