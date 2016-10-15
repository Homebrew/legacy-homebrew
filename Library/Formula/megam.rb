require "formula"

class Megam < Formula
  homepage "http://www.umiacs.umd.edu/~hal/megam/"
  url "http://eightnine.de/megam/megam-0.9.2.tgz"
  sha1 "c9936d0504da70b774ba574c00fcfac48dcc366c"

  depends_on "objective-caml"

  def install
    # Environment settings for Makefile to compile on MacOS
    ENV['WITHCLIBS'] = "-I #{Formula['objective-caml'].lib}/ocaml/caml"
    ENV['WITHSTR']   = "str.cma -cclib -lcamlstr"
    # Build the non-optimized version
    system "make", "-e"
    bin.install "megam"
    system "make", "clean"
    # Build the optimized version
    system "make", "-e", "opt"
    bin.install "megam.opt"
  end

  test do
    (testpath/"tiny.megam").write <<-EOS.undent
      0    F1 F2 F3
      1    F2 F3 F8
      0    F1 F2
      1    F8 F9 F10
    EOS
    system bin/"megam", "binary", "tiny.megam"
    system bin/"megam.opt", "binary", "tiny.megam"
  end
end
