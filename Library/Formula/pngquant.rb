class Pngquant < Formula
  homepage "http://pngquant.org/"
  url "https://github.com/pornel/pngquant/archive/2.3.5.tar.gz"
  sha256 "8907787afca9b83aefe7e29dbf29f4d107255160d0f32c43e7c159ebc2b8d1a7"

  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha1 "4c4b52ecd2d0c6e02e6086717277eca258e96239" => :yosemite
    sha1 "73d1b4d1addd90e6c00497ff9403f97b0f6bc855" => :mavericks
    sha1 "5a8b9d3200c479ed3cf7ee0af43dc127c848eacc" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    ENV.append_to_cflags "-DNDEBUG" # Turn off debug
    system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    bin.install "pngquant"
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o" "out.png"
  end
end
