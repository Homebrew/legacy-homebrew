class Hiredis < Formula
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v0.13.0.tar.gz"
  sha256 "416d6cded4795d2223d8703dd9687259cb8c68445b3f73652eb15887297b15bb"

  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    sha256 "ef65430fe81be90a4ffddef916be1a024522186bc04a8ee1ce47850295ebc187" => :yosemite
    sha256 "ce26414bbf7b5b1c6eb4e14381eadaff1177a63e0f32a22232938c7b9825e16a" => :mavericks
    sha256 "f29302f83d77b702ec7fac83197e2ccb3dc90c631afc9ba73b7f1a472c7fb7c7" => :mountain_lion
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
