class Autogen < Formula
  desc "Automated text file generator"
  homepage "http://autogen.sourceforge.net"
  url "http://ftpmirror.gnu.org/autogen/rel5.18.4/autogen-5.18.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autogen/rel5.18.4/autogen-5.18.4.tar.xz"
  sha256 "7fbaff0c25035aee5b96913de2c83d9a5cc973b8dc08d6b7489ecbcfd72eb84b"

  bottle do
    revision 1
    sha256 "351cd4892f35d90e5a1b0eb4be71bb6126d602232447e4515d4891f82fbb14d5" => :el_capitan
    sha256 "ddea0b5b166275b51510338a6d40f411d5f810f665cb67709d1a9682d3469bbd" => :yosemite
    sha256 "6ad68b38263c1e86196cce1de18ca7e313e6e4788bb55271a9d7a0e625227182" => :mavericks
    sha256 "1b08835f4bfc2f62379b6c13a5fcc77292a136ad06ff22fb4a8d12a2404793fa" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end
