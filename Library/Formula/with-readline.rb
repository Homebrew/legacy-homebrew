class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "http://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "http://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"

  bottle do
    cellar :any
    sha1 "465e7ae270b503a83bbdfc04703fea2a293d67f1" => :yosemite
    sha1 "4d93c4c6724fb8f2fa97db8f292b87727b62b7aa" => :mavericks
    sha1 "ad1b2fa7bf448e4fad18f93dc23e43521dce1857" => :mountain_lion
  end

  depends_on "readline"

  option :universal

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "echo 'exit' | #{bin}/with-readline /usr/bin/expect"
  end
end
