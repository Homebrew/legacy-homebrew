require 'formula'

class Fdupes < Formula
  homepage 'https://github.com/adrianlopezroche/fdupes'
  url 'https://github.com/adrianlopezroche/fdupes/archive/fdupes-1.51.tar.gz'
  sha1 'ac713d3f84dc9d7929f8a4dc1f7d700ddef58d60'

  def install
    inreplace "Makefile", "gcc", "#{ENV.cc} #{ENV.cflags}"
    system "make fdupes"
    bin.install "fdupes"
    man1.install "fdupes.1"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
