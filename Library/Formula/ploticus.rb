class Ploticus < Formula
  desc "Scriptable plotting and graphing utility"
  homepage "http://ploticus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ploticus/ploticus/2.42/ploticus242_src.tar.gz"
  version "2.42"
  sha256 "3f29e4b9f405203a93efec900e5816d9e1b4381821881e241c08cab7dd66e0b0"
  revision 1

  bottle do
    sha256 "088f4ba0eea75ed4b401f94331b70dd64e23f02fa0d95731fbaccf6904c8cea5" => :el_capitan
    sha256 "b15be72d80abf16b348c625945de811bf1fb411b1cb329adc701bc04cfb41dd8" => :yosemite
    sha256 "c2b4982907f4a9de66973cf55729fed03f17c42704593d6dbcce955ce53cd9bb" => :mavericks
  end

  depends_on "libpng"

  def install
    # Use alternate name because "pl" conflicts with OS X "pl" utility
    args=["INSTALLBIN=#{bin}",
          "EXE=ploticus"]
    inreplace "src/pl.h", /#define\s+PREFABS_DIR\s+""/, "#define PREFABS_DIR \"#{pkgshare}\""
    system "make", "-C", "src", *args
    # Required because the Makefile assumes INSTALLBIN dir exists
    bin.mkdir
    system "make", "-C", "src", "install", *args
    pkgshare.install Dir["prefabs/*"]
  end

  def caveats; <<-EOS.undent
    Ploticus prefabs have been installed to #{opt_pkgshare}
  EOS
  end

  test do
    assert_match "ploticus 2.", shell_output("#{bin}/ploticus -version 2>&1", 1)

    (testpath/"test.in").write <<-EOS
#proc areadef
  rectangle: 1 1 4 2
  xrange: 0 5
  yrange: 0 100

#proc xaxis:
  stubs: text
  Africa
  Americas
  Asia
  Europe,\\nAustralia,\\n\& Pacific
EOS
    system "#{bin}/ploticus", "-f", "test.in", "-png", "-o", "test.png"
    assert_match "PNG image data", shell_output("file test.png")
  end
end
