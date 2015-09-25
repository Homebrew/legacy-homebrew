class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "http://www.bitwizard.nl/mtr/"

  stable do
    url "ftp://ftp.bitwizard.nl/mtr/mtr-0.86.tar.gz"
    sha256 "c5d948920b641cc35f8b380fc356ddfe07cce6a9c6474afe242fc58113f28c06"

    # This patch enables mtr to use ncurses use-default-colors()
    patch do
      url "https://github.com/traviscross/mtr/commit/63a1f14.patch"
      sha256 "67d682b29fca49d703f48bb2844e1c0e4b4635d0645d139a13352d9575336194"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "06b43ecc7ac538e43a3835998317e9cd7673ff6015f1a2436c985540c454af95" => :el_capitan
    sha1 "8c08e6d32997d6a82ee755de600ba5d63cc50a4e" => :yosemite
    sha1 "8cc2160f36567c5a0e913c0e0a9f60b9e835ba28" => :mavericks
    sha1 "be91d5c1ad604d190ef1e1d56842592b816197bf" => :mountain_lion
  end

  head do
    url "https://github.com/traviscross/mtr.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    mtr requires root privileges so you will need to run `sudo mtr`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
