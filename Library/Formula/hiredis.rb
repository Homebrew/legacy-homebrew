class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v0.13.1.tar.gz"
  sha256 "8865105e15331156a74b64aafbfd3f8c784a8375e003a55512dcca3d82168487"

  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    sha256 "cbcfc5ac79ad99522782df9359843891878278f5abbee0e35bb502b8a4f3ea00" => :yosemite
    sha256 "86f08f41e2a520b33d3cf57065dd734807747965aca10ad2422183c301052f13" => :mavericks
    sha256 "ad6fc97188b03efc75810be131ce6c565cc399fbf88b3e4cd256edbaa72e37c9" => :mountain_lion
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    system "make", "install", "PREFIX=#{prefix}"
    share.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}", "-lhiredis",
           share/"examples/example.c", "-o", testpath/"test"
    File.exist? testpath/"test"
  end
end
