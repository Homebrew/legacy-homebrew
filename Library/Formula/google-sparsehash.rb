class GoogleSparsehash < Formula
  desc "Extremely memory-efficient hash_map implementation"
  homepage "https://code.google.com/p/google-sparsehash/"
  url "https://sparsehash.googlecode.com/files/sparsehash-2.0.2.tar.gz"
  sha256 "2ed639a7155607c097c2029af5f4287296595080b2e5dd2e2ebd9bbb7450b87c"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "dabf4fbfd790e1c5f359de981d34fb303619f20c5ed68fb7089713931c2c1940" => :el_capitan
    sha256 "538219894b3a02997643a82e35ebbf135e7ccb8c0846038e6e4b0c3baf0c33d3" => :yosemite
    sha256 "30c4265ee1c88a01a2821655ff648a3ccb476cb6f29e2594a042ec76d0f8f52e" => :mavericks
  end

  option :cxx11
  option "without-check", "Skip build-time tests (not recommended)"

  # Patch from upstream issue: https://code.google.com/p/sparsehash/issues/detail?id=99
  patch do
    url "https://gist.githubusercontent.com/jacknagel/3314c8cc67032a912f8b/raw/387b44a3b46e7b68876dbcb3c6595d700fa08a3c/sparsehash.diff"
    sha256 "c12f68278bce1ebf893ffa791e43df7f09e5452db3fbd13bd30fcf91cbf6ad36"
  end

  # see discussion in #41087
  # patch taken from upstream
  patch do
    url "https://github.com/sparsehash/sparsehash/commit/7f6351fb06241b96fdb39ae3aff53c2acb1cd7a4.diff"
    sha256 "3a0b3facdf2b5e61274239b754f4f8ef1c1da185a14e1549f27855d4aa5973ea"
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
