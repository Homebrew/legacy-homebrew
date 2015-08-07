class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "http://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/release-1.5.5.tar.gz"
  sha256 "dbe5dd4e0d35eb36f1f6870fa820c841db9cbbef4090d4b4e5bb10f4ea37882c"
  head "https://github.com/xach/buildapp.git"

  bottle do
    sha256 "f854e3f08c1b6e361df0466ad13e4653a1630c367a8357bab3f1095915c28e58" => :yosemite
    sha256 "11fbf1a1358580ce6558e5d3f5944b9e32af62d7338f806f350eda779d8715ee" => :mavericks
    sha256 "e64ae1125b020eeede5ac83103cfcb30eaec8e960d103f6c3392a31465b590a4" => :mountain_lion
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
