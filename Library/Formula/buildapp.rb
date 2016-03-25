class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "http://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/release-1.5.5.tar.gz"
  sha256 "dbe5dd4e0d35eb36f1f6870fa820c841db9cbbef4090d4b4e5bb10f4ea37882c"
  head "https://github.com/xach/buildapp.git"

  bottle do
    sha256 "1cef949f130b93ef0726c51653e204df326bab606dc787e61da12f4d2e061fd0" => :el_capitan
    sha256 "71e3f67dd4b480bc565933f8afa20b0e8164a02527beb4df97a639fb4673022c" => :yosemite
    sha256 "d489a1979f0c262d2e104e4a69afacb2bdd18fecd261ad182d95867225ca3d10" => :mavericks
    sha256 "e457be5e4a396afa7b748913cd52dac9935b911c8b68e6ede8745b56509a76be" => :mountain_lion
  end

  depends_on "sbcl"

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    code = "(defun f (a) (declare (ignore a)) (write-line \"Hello, homebrew\"))"
    system "#{bin}/buildapp", "--eval", code,
                              "--entry", "f",
                              "--output", "t"
    assert_equal `./t`, "Hello, homebrew\n"
  end
end
