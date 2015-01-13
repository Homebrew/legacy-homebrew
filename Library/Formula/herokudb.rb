require 'formula'

class Herokudb < Formula
  homepage 'https://github.com/taptalk/herokudb'
  url 'https://github.com/taptalk/herokudb/archive/0.0.2.tar.gz'
  sha1 '53e5168952d648c4bd4f38c1d82cc38a59863f43'

  def install
    bin.install "herokudb"
  end

  test do
    system "#{bin}/herokudb", "version"
  end
end
