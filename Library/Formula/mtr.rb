require 'formula'

class Mtr < Formula
  homepage 'http://www.bitwizard.nl/mtr/'

  stable do
    url "ftp://ftp.bitwizard.nl/mtr/mtr-0.85.tar.gz"
    sha1 "6e79584265f733bea7f1b2cb13eeb48f10e96bba"

    patch do
      url "https://github.com/traviscross/mtr/commit/edd425.diff"
      sha1 "c1ed669cdf65d607f75abc729a333b180ee42343"
    end
  end

  head do
    url 'https://github.com/traviscross/mtr.git'
    depends_on :autoconf
    depends_on :automake
  end

  depends_on 'pkg-config' => :build
  depends_on 'gtk+' => :optional
  depends_on 'glib' => :optional

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV['LIBS'] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--without-gtk" if build.without? 'gtk+'
    args << "--without-glib" if build.without? 'glib'
    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    mtr requires superuser privileges. You can either run the program
    via `sudo`, or change its ownership to root and set the setuid bit:

      sudo chown root:wheel #{sbin}/mtr
      sudo chmod u+s #{sbin}/mtr

    In any case, you should be certain that you trust the software you
    are executing with elevated privileges.
    EOS
  end
end
