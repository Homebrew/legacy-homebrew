class Mkvalidator < Formula
  desc "Tool to verify Matroska and WebM files for spec conformance"
  homepage "https://www.matroska.org/downloads/mkvalidator.html"
  url "https://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.5.0.tar.bz2"
  sha256 "c3e72e5b49d32174415b9273ea8d52380e09ac63c8dc7db684104021c711c104"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "fe23d687f75ca9d28b75c9886b0eca1830861f2d47d5e03eea8d9cae0f2f0441" => :el_capitan
    sha256 "e10253ba9942b7d4d92a66efd55fb04671af4edd73bddeed302f5373591d244f" => :yosemite
    sha256 "8a6c2abe6c63609e04f4855f25b336418d6ae9f10f95061c40efd811372afb0f" => :mavericks
  end

  # see https://sourceforge.net/p/matroska/bugs/9/
  # and https://sourceforge.net/p/matroska/patches/3/
  if MacOS.prefer_64_bit?
    patch do
      url "https://sourceforge.net/p/matroska/patches/_discuss/thread/8899370c/81cc/attachment/mkvalidator-0.3.7.gcc_osx_x64.build.diff"
      sha256 "c714977d5b68e90851ce59aacc789438b2455741eba43bd473a248a59932ce3c"
    end
  end

  resource "tests" do
    url "https://github.com/dunn/garbage/raw/c0e682836e5237eef42a000e7d00dcd4b6dcebdb/test.mka"
    sha256 "6d7cc62177ec3f88c908614ad54b86dde469dbd2b348761f6512d6fc655ec90c"
  end

  def install
    ENV.j1 # Otherwise there are races
    system "./configure"
    system "make", "-C", "mkvalidator"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkvalidator"
  end

  test do
    resource("tests").stage do
      system bin/"mkvalidator", "test.mka"
    end
  end
end
