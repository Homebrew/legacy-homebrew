require 'formula'

class Bowtie < Formula
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie/0.12.7/bowtie-0.12.7-src.zip'
  homepage 'http://bowtie-bio.sourceforge.net/index.shtml'
  md5 '2808d61eaf15c9f7138794766c99a561'

  def install
    system "make"
    bin.install %W(bowtie bowtie-build bowtie-inspect)
  end
end
