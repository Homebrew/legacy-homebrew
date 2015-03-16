class Flasm < Formula
  homepage "http://www.nowrap.de/flasm.html"
  url "http://www.nowrap.de/download/flasm16src.zip"
  sha256 "df1273a506e2479cf95775197f5b7fa94e29fe1e0aae5aa190ed5bbebc4be5c6"
  version "1.62"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "flasm"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      constants 'a', 'b'
      push 'a', 'b'
      getVariable
      push 'b'
      getVariable
      multiply
      setVariable
    EOS

    system "#{bin}/flasm", "-b", "test"
  end
end
