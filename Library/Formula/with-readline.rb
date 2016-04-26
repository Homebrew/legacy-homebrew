class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "http://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "http://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"

  bottle do
    cellar :any
    revision 1
    sha256 "848877aac84004600d25c5b0ae87c12c2165a8fbc4c31c75bb82c225e5b4a833" => :el_capitan
    sha256 "b597b2c5fdebc55699be29bb356926244bd8f7ea9c7eca02ba0ca41c319c70de" => :yosemite
    sha256 "81fe9d0d8e723821ee68a47110ace135b6d865756f00364f758f6ac0d03eb1f2" => :mavericks
  end

  option :universal

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/with-readline /usr/bin/expect", "exit", 0)
  end
end
