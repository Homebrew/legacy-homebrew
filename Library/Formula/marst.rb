class Marst < Formula
  desc "Algol-to-C translator"
  homepage "https://www.gnu.org/software/marst"
  url "http://ftpmirror.gnu.org/marst/marst-2.7.tar.gz"
  sha256 "3ee7b9d1cbe3cd9fb5f622717da7bb5506f1a6da3b30f812e2384b87bce4da50"

  bottle do
    cellar :any
    sha1 "517892e7d7575e99143685739a93f2bea6d655e1" => :mavericks
    sha1 "2f4059e7e7c73292a5a61c82887393a9537f9913" => :mountain_lion
    sha1 "7574be85edd2f0e4fa4283f2a6c4e300620442e7" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.alg").write('begin outstring(1, "Hello, world!\n") end')
    system "#{bin}/marst -o hello.c hello.alg"
    system "#{ENV.cc} hello.c -lalgol -lm -o hello"
    system "./hello"
  end
end
