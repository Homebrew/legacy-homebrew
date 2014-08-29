require "formula"

class Global < Formula
  homepage "https://www.gnu.org/software/global/"
  url "http://ftpmirror.gnu.org/global/global-6.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.3.tar.gz"
  sha1 "01180de13918a29d4af62ed9c86dbe84ed16f550"

  bottle do
    sha1 "e004212ac52962c8d8b5164cbc6c46fcc47f3557" => :mavericks
    sha1 "d7d3b6896bcbb41dc45046e960352c60d4c63b99" => :mountain_lion
    sha1 "9838c4345cda516d7de7212322b91eb08e821c45" => :lion
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
