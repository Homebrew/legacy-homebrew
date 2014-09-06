require "formula"

class Global < Formula
  homepage "https://www.gnu.org/software/global/"
  url "http://ftpmirror.gnu.org/global/global-6.3.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.3.2.tar.gz"
  sha1 "46b681a0ccb84c928a67f6901ca60227ad71b5bd"

  bottle do
  end

  head do
    url "cvs://:pserver:anonymous:@cvs.savannah.gnu.org:/sources/global:global"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-exuberant-ctags", "Enable Exuberant Ctags as a plug-in parser"

  if build.with? "exuberant-ctags"
    depends_on "ctags"
    skip_clean "lib/gtags/exuberant-ctags.la"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    if build.with? "exuberant-ctags"
      args << "--with-exuberant-ctags=#{HOMEBREW_PREFIX}/bin/ctags"
    end

    system "./configure", *args
    system "make install"

    etc.install "gtags.conf"

    # we copy these in already
    cd share/"gtags" do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end
