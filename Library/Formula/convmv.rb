class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "http://www.j3e.de/linux/convmv/"
  url "http://www.j3e.de/linux/convmv/convmv-1.15.tar.gz"
  sha256 "c315aec78490b588000467d1c51081b36e629de0537c5a17fd48b1acaf8a5135"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/convmv", "--list"
  end
end
