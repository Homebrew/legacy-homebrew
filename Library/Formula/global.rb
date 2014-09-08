require "formula"

class Global < Formula
  homepage "https://www.gnu.org/software/global/"
  url "http://ftpmirror.gnu.org/global/global-6.3.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.3.2.tar.gz"
  sha1 "46b681a0ccb84c928a67f6901ca60227ad71b5bd"

  bottle do
    sha1 "1bce9bd552e38d9cc12eda4998233c20a33321e4" => :mavericks
    sha1 "907a3a0180b4b4ea6ecc029b864a7ed4c8e1fa21" => :mountain_lion
    sha1 "254d7f4444b1890b1195f35a6e1f43ed34dace7d" => :lion
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
