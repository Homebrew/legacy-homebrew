class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  stable do
    url "http://www.minizinc.org/downloads/release-2.0.1/libminizinc-2.0.1.tar.gz"
    sha256 "b2dedd456d71d5670b24ec4b159a05d53c00e2aae232171c0e3be31cec915aff"

    patch do
      url "https://github.com/MiniZinc/libminizinc/commit/5c9341c32df7f6d1f11249bc93ef62fd860444ab.diff"
      sha256 "30562c42e08bda8f79ff87e53054c7def125ce5e4a7ee1d74599068bdd572505"
    end
  end
  bottle do
    cellar :any
    sha256 "ae9f777c740457c2d5698e339ac0434682f43bbc1e154cf797d586647624e5bf" => :yosemite
    sha256 "58bf476cbe2181e3a6420aa709ade2aecde6b400a70f291aeb7c3a7e747d1e05" => :mavericks
    sha256 "d5d00aeaf5f6bb6b3f2cb0d78a29271d98fa73deeb7d939055992f631da78f34" => :mountain_lion
  end


  depends_on :arch => :x86_64
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      system "make", "install"
    end
  end

  test do
    system bin/"mzn2doc", share/"examples/functions/warehouses.mzn"
  end
end
