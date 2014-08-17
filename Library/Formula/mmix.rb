require "formula"

class Mmix < Formula
  homepage "http://mmix.cs.hm.edu/"
  url "http://mmix.cs.hm.edu/src/mmix-20131017.tgz"
  sha1 "75dba738c72fb163302160e745096846a7b8672a"

  bottle do
    cellar :any
    sha1 "3203586ea18c63f2332cd7d52e739f87c6bf71c6" => :mavericks
    sha1 "cc8eeb7fe526992122ddf3a42fc422837b18a0d4" => :mountain_lion
    sha1 "d1cddd4fff7468c8234f3362d42b2a4bfbd17cee" => :lion
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
