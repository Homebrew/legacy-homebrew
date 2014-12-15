require 'formula'

class Buildapp < Formula
  homepage 'http://www.xach.com/lisp/buildapp/'
  url 'https://github.com/xach/buildapp/archive/release-1.5.3.tar.gz'
  sha1 'a0601d144ee72719bd92298ca90e155234de26d0'

  bottle do
    sha1 "b5c93a13dea8b09844376e285fbc531ae24ab608" => :yosemite
    sha1 "023440a32a3f053d4eba20534a73d4cc6ed9a8f7" => :mavericks
    sha1 "eeb8f81c772672fbffdeca7e659cd8f57039dc1c" => :mountain_lion
  end

  depends_on 'sbcl'

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
