require 'formula'

class Buildapp < Formula
  homepage 'http://www.xach.com/lisp/buildapp/'
  url 'https://github.com/xach/buildapp/archive/release-1.5.3.tar.gz'
  sha1 'a0601d144ee72719bd92298ca90e155234de26d0'

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
