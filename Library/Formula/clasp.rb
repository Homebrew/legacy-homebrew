class Clasp < Formula
  desc "Answer set solver for (extended) normal logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/clasp/3.1.3/clasp-3.1.3-source.tar.gz"
  sha256 "f08684eadfa5ae5efa5c06439edc361b775fc55b7c1a9ca862eda8f5bf7e5f1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1c8dff2446da52ad0d87fc53f14065ef9d92e6a66d27ecd8ed3e7619b6bddea" => :el_capitan
    sha256 "1cb2579b887870f73fc216c474e841951b01ff26f120273bf536665403f65826" => :yosemite
    sha256 "06c9bce4ff95e45e4fb78351c658f2d4bbc80fadd2db581e6b9673ec383d4755" => :mavericks
    sha256 "20058e023ad293199f0c1619953adaea03f84aa25c07f42e3edb9d177447cd52" => :mountain_lion
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
