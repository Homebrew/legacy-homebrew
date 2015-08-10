class Clasp < Formula
  desc "Answer set solver for (extended) normal logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/clasp/3.1.3/clasp-3.1.3-source.tar.gz"
  sha256 "f08684eadfa5ae5efa5c06439edc361b775fc55b7c1a9ca862eda8f5bf7e5f1f"

  bottle do
    cellar :any
    sha256 "d55865143a46df97accfa26272d8e0e126c7aa4b0c7dc47dd792e971563b6f77" => :yosemite
    sha256 "8cfe71e8a7df4fb78c8a5adfc0cb196e570a92a33684eb8dec10e8306b816fd6" => :mavericks
    sha256 "8a9687f4b906e97b44f6f865b1f4474a56f92398ff4b7a88f5890b2b95564056" => :mountain_lion
  end

  option "with-mt", "Enable multi-thread support"

  depends_on "tbb" if build.with? "mt"

  def install
    if build.with? "mt"
      ENV["TBB30_INSTALL_DIR"] = Formula["tbb"].opt_prefix
      build_dir = "build/release_mt"
    else
      build_dir = "build/release"
    end

    args = %W[
      --config=release
      --prefix=#{prefix}
    ]
    args << "--with-mt" if build.with? "mt"

    bin.mkpath
    system "./configure.sh", *args
    system "make", "-C", build_dir, "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/clasp --version")
  end
end
