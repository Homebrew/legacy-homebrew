class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/"
  head "https://github.com/jech/babeld.git"

  stable do
    url "http://www.pps.univ-paris-diderot.fr/~jch/software/files/babeld-1.5.1.tar.gz"
    sha1 "6ff3a7685e62034df83b143a36a4960b2e4d89b9"

    patch do
      url "https://github.com/jech/babeld/commit/049003.diff"
      sha1 "acbe00c7591476f96b3494cb7a4685b3a4dc7513"
    end
  end

  bottle do
    cellar :any
    sha1 "a965f70b84f8fea7ce7a7f92252e61d01a6b9e7b" => :yosemite
    sha1 "22262a12d06cf83d35f351a49d6af7e40e7f554d" => :mavericks
    sha1 "69e5c32092ccfdaeaff3615fbbaf15e41e327e41" => :mountain_lion
  end

  def install
    system "make", "LDLIBS=''"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Due to changing network interfaces, this tool
    requires the usage of `sudo` at runtime.
    EOS
  end
end
