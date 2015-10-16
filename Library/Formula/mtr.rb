class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.86.tar.gz"
  sha256 "7912f049f9506748913e2866068b7f95b11a4e0a855322120b456c46ac9eb763"
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06b43ecc7ac538e43a3835998317e9cd7673ff6015f1a2436c985540c454af95" => :el_capitan
    sha1 "8c08e6d32997d6a82ee755de600ba5d63cc50a4e" => :yosemite
    sha1 "8cc2160f36567c5a0e913c0e0a9f60b9e835ba28" => :mavericks
    sha1 "be91d5c1ad604d190ef1e1d56842592b816197bf" => :mountain_lion
  end

  depends_on "automake" => :build
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
    system "./bootstrap.sh"
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    mtr requires root privileges so you will need to run `sudo mtr`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
