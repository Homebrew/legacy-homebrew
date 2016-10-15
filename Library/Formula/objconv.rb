require "formula"

class Objconv < Formula
  homepage "http://www.agner.org/optimize"
  url "http://www.agner.org/optimize/objconv.zip"
  version "2.36"
  sha1 "eaf894e09786827eddad73f7866be0411762512e"

  depends_on "nasm"

  def install
    system "tar", "xvf", "source.zip"
    system "#{ENV.cxx} -o objconv -O2 #{buildpath}/*.cpp"
    bin.install "objconv"
  end

  test do
    (testpath/"nasm.s").write("INT 0x8000")

    system "nasm", "-fmacho", testpath/"nasm.s"

    system bin/"objconv", "-fnasm", testpath/"nasm.o"
  end
end
