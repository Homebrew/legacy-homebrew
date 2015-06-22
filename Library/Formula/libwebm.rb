class Libwebm < Formula
  desc "WebM container"
  homepage "http://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/libwebm-1.0.0.26.tar.gz"
  sha256 "1e4034e03836ac974bb078b11383a10306d63879b350a34fdd575ab44b132222"

  def install
    system "make"

    lib.install "libwebm.a"
    include.install Dir.glob("mkv*.hpp")
    include.install Dir.glob("vtt*.h")
    bin.install %w[dumpvtt samplemuxer vttdemux]
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <mkvwriter.hpp>
      int main()
      {
        mkvmuxer::MkvWriter writer();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lwebm", "-o", "test"
    system "./test"
  end
end
