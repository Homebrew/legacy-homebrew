require 'formula'

class Snownews < Formula
  homepage 'https://kiza.eu/software/snownews'
  url 'https://kiza.eu/media/software/snownews/snownews-1.5.12.tar.gz'
  sha1 'b3addaac25c2c093aa5e60b8b89e50e7d7450bcf'

  depends_on 'gettext' => :build

  def patches
    "http://gist.github.com/benjaminweb/5936137/raw" #fixes zlib linking
  end

  def install

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

end
