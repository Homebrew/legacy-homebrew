class Mtr < Formula
  homepage "http://www.bitwizard.nl/mtr/"
  url "ftp://ftp.bitwizard.nl/mtr/mtr-0.86.tar.gz"
  sha1 "2c81d0f4c9296861a1159f07eec6acfb4bebecf7"

  head do
    url "https://github.com/traviscross/mtr.git"
    depends_on "automake" => :build
  end

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+" => :optional
  depends_on "glib" => :optional

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV["LIBS"] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--without-gtk" if build.without? "gtk+"
    args << "--without-glib" if build.without? "glib"
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
