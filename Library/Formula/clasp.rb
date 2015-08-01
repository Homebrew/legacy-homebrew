require "formula"

class Clasp < Formula
  desc "An answer set solver for (extended) normal logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/clasp/3.1.2/clasp-3.1.2-source.tar.gz"
  sha256 "77d5b8fc9617436f7ba37f3c80ad2ce963dfefb7ddaf8ae14d5a4f40a30cc9d3"

  bottle do
    cellar :any
    sha1 "0ac56c1eb46713865ead22812d8000978e0ff63b" => :yosemite
    sha1 "b40b58db856ac11dfbaa64fb28213bc3350fc986" => :mavericks
    sha1 "16aca848e54eae150b7f6b2a3d9d8bdd4d510fac" => :mountain_lion
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
