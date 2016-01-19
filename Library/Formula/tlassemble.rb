class Tlassemble < Formula
  desc "Create time lapse movies from image sequences"
  homepage "http://www.dayofthenewdan.com/projects/tlassemble/"
  url "https://github.com/dbridges/cocoa-tlassemble/archive/v1.0.tar.gz"
  sha256 "ce56ebf60665a4f400b8f4b9157825bdb3f6b2034c522c93f5137ecd671fc7c6"

  def install
    system "make"
    bin.install "tlassemble"
  end

  test do
    system "\"#{bin}/tlassemble\" --help | grep 'tlassemble 1.0'"
  end
end
