class Mmix < Formula
  desc "64-bit RISC architecture designed by Donald Knuth"
  homepage "http://mmix.cs.hm.edu/"
  url "http://mmix.cs.hm.edu/src/mmix-20131017.tgz"
  sha256 "aa64c4b9dc3cf51f07b330791f8ce542b0ae8a1132e098fa95a19b31350050b4"

  bottle do
    cellar :any
    sha256 "6c4c3827aeb30811a8b611cd4a32fd03891176461a0574d605afc7366f4c6b24" => :mavericks
    sha256 "1923c3763f050c857b32695d5d01488159e677803aa6fd0cc9e2ba563e7424b1" => :mountain_lion
    sha256 "9753b9a76618842b5c1d1d14d3ed0505aa233515db53465aa476e04dd186e548" => :lion
  end

  depends_on "cweb" => :build

  def install
    ENV.deparallelize

    system "make", "all"

    bin.install "mmix", "mmixal", "mmmix", "mmotype"
  end

  test do
    (testpath/"hello.mms").write <<-EOS
      LOC  Data_Segment
      GREG @
txt   BYTE "Hello world!",0

      LOC #100

Main  LDA $255,txt
      TRAP 0,Fputs,StdOut
      TRAP 0,Halt,0
    EOS
    system bin/"mmixal", "hello.mms"
    assert_equal "Hello world!", `mmix hello.mmo`
  end
end
