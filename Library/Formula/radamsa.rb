class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://code.google.com/p/ouspg/wiki/Radamsa"
  url "https://ouspg.googlecode.com/files/radamsa-0.3.tar.gz"
  sha256 "17131a19fb28e5c97c28bf0b407a82744c251aa8aedfa507967a92438cd803be"

  def install
    system "make"
    man1.install "doc/radamsa.1"
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    The Radamsa binary has been installed.
    The Lisp source code has been copied to:
      #{prefix}/rad

    To be able to recompile the source to C, you will need run:
      $ make get-owl

    Tests can be run with:
      $ make .seal-of-quality

    EOS
  end

  test do
    system bin/"radamsa", "-V"
  end
end
