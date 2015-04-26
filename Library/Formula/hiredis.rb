class Hiredis < Formula
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v0.13.0.tar.gz"
  sha256 "416d6cded4795d2223d8703dd9687259cb8c68445b3f73652eb15887297b15bb"

  head "https://github.com/redis/hiredis.git"

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
