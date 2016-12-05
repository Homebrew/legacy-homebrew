class Ired < Formula
  desc "Minimalistic hexadecimal editor designed to be used in scripts."
  homepage "https://github.com/radare/ired"
  url "http://www.radare.org/get/ired-0.5.0.tar.gz"
  sha256 "dce25f6b9402b78f183ecf4d94a2d44db1a6946546217d6c60c3f179bfbfff84"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = <<-EOS.undent
      w"hello wurld"
      s+7
      r-4
      w"orld"
      q
    EOS
    pipe_output("#{bin}/ired test.text", input)
    assert_equal "hello world", (testpath/"test.text").read.chomp
  end
end
