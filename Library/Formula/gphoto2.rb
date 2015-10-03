class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.8/gphoto2-2.5.8.tar.bz2"
  sha256 "a9abcd15d95f205318d17e3ac12af7ce523d2bc4943709d50b0a12c30cc5ee4d"

  bottle do
    cellar :any
    sha256 "ae8d38e94f0ff037eb26e248413877ef7e8045b1b05fdfd6d357f2a1bf92d84f" => :el_capitan
    sha256 "6d57973dbb611b2b77776d67ad35519f163621dc93e6a0deb23f3ffccc67c71f" => :yosemite
    sha256 "b665dcc42de947a48e66cf4251104f003bc7c1c881c73b67b9d1cb48430257c9" => :mavericks
    sha256 "34da8bdafd4e10cb03a03bf8ccd3dbf193fc66c93c638bd9631f8dffba014a6b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
