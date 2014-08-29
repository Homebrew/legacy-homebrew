require 'formula'

class Libcsv < Formula
  homepage 'http://sourceforge.net/projects/libcsv/'
  url 'https://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.3/libcsv-3.0.3.tar.gz'
  sha1 '2f637343c3dfac80559595f519e8f78f25acc7c1'

  bottle do
    cellar :any
    sha1 "81a516debf829ccf7232234abf8c89f83b312ee3" => :mavericks
    sha1 "7a55b80deebbfef143978927829b22d20d8c4a5e" => :mountain_lion
    sha1 "a3c670cf58ed91cce8c5cece8b998557395e043c" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system 'make'
    system 'make install'
  end
end
