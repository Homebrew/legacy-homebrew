class Nedit < Formula
  homepage "http://www.nedit.org"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.6-src.tar.gz"
  sha1 "133641224b0969e31e3404b874c71c35341f028b"

  depends_on :x11
  depends_on "openmotif"

  def install
    inreplace "util/motif.c" do |s|
      s.gsub! /200303/, "200304"
    end

    system "make", "macosx", "MOTIFLINK='-lXm'"
    mv "source/nc", "source/ncl"

    make_doc_args = %W[ -C doc man doc ]
    system "make", *make_doc_args

    bin.install "source/nedit"
    bin.install "source/ncl"

    man1.install "doc/nedit.man" => "nedit.1"
    man1.install "doc/nc.man" => "ncl.1"

    doc.install Dir["doc/*"]
  end

  test do
    system bin/"nedit", "-version"
    system bin/"ncl", "-version"
  end
end
