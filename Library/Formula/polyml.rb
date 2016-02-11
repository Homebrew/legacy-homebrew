class Polyml < Formula
  desc "Standard ML implementation"
  homepage "http://www.polyml.org"
  url "https://github.com/polyml/polyml/archive/v5.6.tar.gz"
  sha256 "20d7b98ae56fe030c64054dbe0644e9dc02bae781caa8994184ea65a94a0a615"
  head "https://github.com/polyml/polyml.git"

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
