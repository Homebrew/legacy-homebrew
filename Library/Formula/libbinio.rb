require 'formula'

class Libbinio < Formula
  homepage 'http://libbinio.sf.net'
  url 'https://downloads.sourceforge.net/project/libbinio/libbinio/1.4/libbinio-1.4.tar.bz2'
  sha1 '47db5f7448245f38b9d26c8b11f53a07b6f6da73'

  bottle do
    cellar :any
    sha1 "68f94ad8d5fb81408ad97faf1b562384a25b643c" => :yosemite
    sha1 "6d4f265305ae6c4b44c4fd299aca20ceba8f07be" => :mavericks
    sha1 "e59427d1947751afe72244b5387e662dfa91f899" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
