class Minizinc < Formula
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
