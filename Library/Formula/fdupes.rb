require 'formula'

class Fdupes < Formula
  homepage 'http://code.google.com/p/fdupes/'
  url 'https://fdupes.googlecode.com/files/fdupes-1.51.tar.gz'
  sha1 '8276b39026f57a2f9503d7af18efca0a7d42b8ec'

  def install
    inreplace "Makefile", "gcc", "#{ENV.cc} #{ENV.cflags}"
    system "make fdupes"
    bin.install "fdupes"
    man1.install "fdupes.1"
  end

  test do
    touch "a"
    touch "b"

    dupes = `#{bin}/fdupes .`.strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
    assert_equal 0, $?.exitstatus
  end
end
