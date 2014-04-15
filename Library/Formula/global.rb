require 'formula'

class Global < Formula
  homepage 'http://www.gnu.org/software/global/'
  url 'http://ftpmirror.gnu.org/global/global-6.2.12.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.2.12.tar.gz'
  sha1 '1fc0948ee76185d38733750567a2bdb6b9b07304'

  bottle do
    sha1 "81160b83cf9bee1e5b97c1c1e40b10f340798f15" => :mavericks
    sha1 "9dfc3ad14ae419089375dd44c4c6e618d1672063" => :mountain_lion
    sha1 "8a5bc30cfd1733ddff466f28bd293a60fa175162" => :lion
  end

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
