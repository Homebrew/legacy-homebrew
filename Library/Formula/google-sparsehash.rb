class GoogleSparsehash < Formula
  desc "Extremely memory-efficient hash_map implementation"
  homepage "https://github.com/sparsehash/sparsehash"
  url "https://github.com/sparsehash/sparsehash/archive/sparsehash-2.0.3.tar.gz"
  sha256 "05e986a5c7327796dad742182b2d10805a8d4f511ad090da0490f146c1ff7a8c"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "dabf4fbfd790e1c5f359de981d34fb303619f20c5ed68fb7089713931c2c1940" => :el_capitan
    sha256 "538219894b3a02997643a82e35ebbf135e7ccb8c0846038e6e4b0c3baf0c33d3" => :yosemite
    sha256 "30c4265ee1c88a01a2821655ff648a3ccb476cb6f29e2594a042ec76d0f8f52e" => :mavericks
  end

  option :cxx11
  option "without-check", "Skip build-time tests (not recommended)"

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
