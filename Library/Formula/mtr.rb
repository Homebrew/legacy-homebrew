class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  head "https://github.com/traviscross/mtr.git"

  stable do
    url "https://github.com/traviscross/mtr/archive/v0.86.tar.gz"
    sha256 "7912f049f9506748913e2866068b7f95b11a4e0a855322120b456c46ac9eb763"

    # Fix an issue where default shell colors were overridden by mtr.
    # https://github.com/Homebrew/homebrew/issues/43862
    patch do
      url "https://github.com/traviscross/mtr/commit/63a1f1493bfbaf7e55eb7e20b3791fc8b14cf92d.patch"
      sha256 "67d682b29fca49d703f48bb2844e1c0e4b4635d0645d139a13352d9575336194"
    end
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "fba272c1219a2386b034110dc129fa484597e7865b544d979386e0bfa0bc7f2e" => :el_capitan
    sha256 "96c3b22edc936bb9b7053a1920f34a524fdc3a6d99d32f5c6313a903d6b3ff1f" => :yosemite
    sha256 "3fb9172a95469e6ee38faeee2e67682f75dd79a6e222426674751846fee5f0a9" => :mavericks
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
