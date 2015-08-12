class Foma < Formula
  desc "Finite-state compiler and C library"
  homepage "https://code.google.com/p/foma/"
  url "https://bitbucket.org/mhulden/foma/downloads/foma-0.9.18.tar.gz"
  sha256 "cb380f43e86fc7b3d4e43186db3e7cff8f2417e18ea69cc991e466a3907d8cbd"

  bottle do
    cellar :any
    sha256 "d50dfd48bb3418d809c7c95d6046a59f550e2089d7e6dbb80327015894f073e1" => :el_capitan
    sha256 "2113796151927413c1bc640f19d8a62083628a1a124657d5d6ca5c9e087b19dd" => :yosemite
    sha256 "19b54c8f060b5adf9e6a0c37a6e59dcf20017b6ae1fe642ea373f0ee0a03f01f" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    # Source: https://code.google.com/p/foma/wiki/ExampleScripts
    (testpath/"toysyllabify.script").write <<-EOS.undent
      define V [a|e|i|o|u];
      define Gli [w|y];
      define Liq [r|l];
      define Nas [m|n];
      define Obs [p|t|k|b|d|g|f|v|s|z];

      define Onset (Obs) (Nas) (Liq) (Gli); # Each element is optional.
      define Coda  Onset.r;                 # Is mirror image of onset.

      define Syllable Onset V Coda;
      regex Syllable @> ... "." || _ Syllable;

      apply down> abrakadabra
    EOS

    system "#{bin}/foma", "-f", "toysyllabify.script"
  end
end
