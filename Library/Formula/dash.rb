class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.8.tar.gz"
  sha256 "c6db3a237747b02d20382a761397563d813b306c020ae28ce25a1c3915fac60f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d08e01233adc37f077c6d27bfc78851846ebeca0ec7e01ec92d67c9eac3d229" => :el_capitan
    sha256 "247132088e1b1e3b3b63ef2c063e9e90eff4830cc5d0bb136f9ee8ae7e5713a0" => :yosemite
    sha256 "06cf9f55f34065fce33b245dfb5166f642325ae52dc94005c2565e991b81c0d9" => :mavericks
    sha256 "34a644c17e05c1506e5ae7d77c60a522c6f7eaf677dd3dd4c00c1b4a769bfda0" => :mountain_lion
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
