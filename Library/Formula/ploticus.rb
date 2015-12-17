class Ploticus < Formula
  desc "Scriptable plotting and graphing utility"
  homepage "http://ploticus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ploticus/ploticus/2.42/ploticus242_src.tar.gz"
  version "2.42"
  sha256 "3f29e4b9f405203a93efec900e5816d9e1b4381821881e241c08cab7dd66e0b0"

  depends_on "libpng"

  def install
    # Use alternate name because "pl" conflicts with OS X "pl" utility
    args=["INSTALLBIN=#{bin}",
          "EXE=ploticus"]
    system "make", "-C", "src", *args
    # Required because the Makefile assumes INSTALLBIN dir exists
    bin.mkdir
    system "make", "-C", "src", "install", *args
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
