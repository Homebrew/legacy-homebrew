class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage "http://mldonkey.sourceforge.net/Main_Page"
  url "https://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.5/mldonkey-3.1.5.tar.bz2"
  sha256 "74f9d4bcc72356aa28d0812767ef5b9daa03efc5d1ddabf56447dc04969911cb"

  bottle do
    sha256 "9114465cb9f08911d215ef0f582e9fd2956c311a35c8db239434670150211c41" => :yosemite
    sha256 "ac3821871d88b51927ed95d04e32ad917be80020a03c1a46cb3e29172b54c446" => :mavericks
    sha256 "43647a2a802978b9e6dcab2a42f4883cd679e151ed8a9775a1ceb82fa993384f" => :mountain_lion
  end

  # Fix a comment that causes an error in recent ocaml;
  # fixed upstream, will be in the next release.
  patch do
    url "https://github.com/ygrek/mldonkey/commit/c91a78896526640a301f5a9eeab8b698923e285c.patch"
    sha256 "1fb503d37eed92390eb891878a9e6d69b778bd2f1d40b9845d18aa3002f3d739"
  end

  depends_on "camlp4" => :build
  depends_on "objective-caml" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libpng"

  def install
    ENV.j1

    # Fix compiler selection
    ENV["OCAMLC"] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
