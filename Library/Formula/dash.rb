class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.8.tar.gz"
  sha256 "c6db3a237747b02d20382a761397563d813b306c020ae28ce25a1c3915fac60f"

  bottle do
    cellar :any
    sha1 "c1ac235981ac608abb8cdf5649676ac3f40afb2d" => :yosemite
    sha1 "b626fcc3d0a9482b32d2c62b6faa99159324ea82" => :mavericks
    sha1 "6f4795d3a2d23d1010b637b4212c664ac9e5055b" => :mountain_lion
  end

  head do
    url "https://git.kernel.org/pub/scm/utils/dash/dash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking",
                          "--enable-fnmatch",
                          "--enable-glob"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
