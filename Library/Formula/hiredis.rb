class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v0.13.1.tar.gz"
  sha256 "8865105e15331156a74b64aafbfd3f8c784a8375e003a55512dcca3d82168487"

  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    revision 1
    sha256 "811867ba0865d4718d23f7539de8615c713aa8e6d0a719b3a2a2f35705e11caf" => :el_capitan
    sha256 "0574fa67843dfe0070123d2bf60a7087701f90195b46ad2d7e7b9f9da321d4d7" => :yosemite
    sha256 "832daedc5036ef20e9cf166ce3817ec2a5da8b0b0808b39e6911154550bb59c7" => :mavericks
    sha256 "ab30e930930d581ae6e86b6a0440692c152004915e14d066f16edc029f9aad6d" => :mountain_lion
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}", "-lhiredis",
           pkgshare/"examples/example.c", "-o", testpath/"test"
    File.exist? testpath/"test"
  end
end
