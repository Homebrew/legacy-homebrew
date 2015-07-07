class T1utils < Formula
  desc "Command-line tools for dealing with Type 1 fonts"
  homepage "http://www.lcdf.org/type/"
  url "http://www.lcdf.org/type/t1utils-1.39.tar.gz"
  sha256 "0faef3e5c4927b38b05ac99ee177b7d7cddbbf5b4452f98b244f684b52b0d4c4"

  bottle do
    cellar :any
    sha256 "1c1db2e4e722c180bde2dfdfc8e180134ee86a3fe8f99f063077f6b9485e8cdf" => :yosemite
    sha256 "c353a67edc6d5ecb0675c9843b21224347fa4eb4035cb298c5d815c02dde5018" => :mavericks
    sha256 "1b83bfc6ed504e2c9ab50e83eace1cfadae785d003ec7aa6c084699e59e38643" => :mountain_lion
  end

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
