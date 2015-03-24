class Cycript < Formula
  homepage "http://www.cycript.org"
  url "git://git.saurik.com/cycript.git",
    :tag => "v0.9.502",
    :revision => "bb99d698a27487af679f8c04c334d4ea840aea7a"
  head "git://git.saurik.com/cycript.git"

  def install
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /20/, pipe_output("#{bin}/cycript", "10 + 10")
  end
end
