class Xmltoman < Formula
  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "010af030c01ebe6528bbdecfa1153fac5f6e082fa088e1803d0768bb268a509b" => :el_capitan
    sha256 "6345ec17095eeec7fde97b609c0c88f07fcdd1e911fa7fd3b8db7f3e5b081b9c" => :yosemite
    sha256 "9330b2e39919f745009122679a1e4f42ff818c55950fd7b462af86de644c0a45" => :mavericks
  end

  def install
    # generate the man files from their original XML sources
    system "./xmltoman xml/xmltoman.1.xml > xmltoman.1"
    system "./xmltoman xml/xmlmantohtml.1.xml > xmlmantohtml.1"

    man1.install %w[xmltoman.1 xmlmantohtml.1]
    bin.install %w[xmltoman xmlmantohtml]
    (share+"xmltoman").install %w[xmltoman.xsl xmltoman.dtd xmltoman.css]
  end
end

