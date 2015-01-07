class Unruu < Formula
  homepage "https://github.com/kmdm/unruu"
  url "https://github.com/kmdm/unruu/archive/v0.1.1.tar.gz"
  sha1 "0717b8cee2de35229e125d607ee91bd8b9ad2871"

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'unshield'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
