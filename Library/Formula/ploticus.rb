class Ploticus < Formula
  desc "Scriptable plotting and graphing utility"
  homepage "http://ploticus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ploticus/ploticus/2.42/ploticus242_src.tar.gz"
  version "2.42"
  sha256 "3f29e4b9f405203a93efec900e5816d9e1b4381821881e241c08cab7dd66e0b0"
  revision 1

  bottle do
    cellar :any
    sha256 "4692b3e6ac406608edda1a7e3a7a209e79b535ad15e5592ed58354d5c06c8da8" => :el_capitan
    sha256 "394fd11e14746155110865f98f3dbab9b54bd6de166ffdbe31e380b20d58c5f1" => :yosemite
    sha256 "1e9f32e1e439d234a0597a33a2a28399995f9a05e1c91901c590b44697c4cbee" => :mavericks
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

  def caveats
    "Ploticus prefabs have been installed to #{pkgshare}"
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
