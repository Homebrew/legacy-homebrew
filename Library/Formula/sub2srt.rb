class Sub2srt < Formula
  desc "Convert subtitles from .sub to subviewer .srt format"
  homepage "https://github.com/robelix/sub2srt"
  url "https://github.com/robelix/sub2srt/archive/0.5.5.tar.gz"
  sha256 "169d94d1d0e946a5d57573b7b7b5883875996f802362341fe1a1a0220229b905"
  head "https://github.com/robelix/sub2srt.git"

  bottle :unneeded

  def install
    bin.install "sub2srt"
  end

  test do
    (testpath/"test.sub").write <<-EOS.undent
      {1100}{1300}time to...|one
      {1350}{1400}homebrew|two
    EOS
    expected = <<-EOS.undent
      1
      00:00:44,000 --> 00:00:52,000
      time to...
      one

      2
      00:00:54,000 --> 00:00:56,000
      homebrew
      two
    EOS
    system "#{bin}/sub2srt", "#{testpath}/test.sub"
    assert_equal expected, (testpath/"test.srt").read.chomp
  end
end
