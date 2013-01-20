require 'formula'

class Bowtie < Formula
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie/0.12.7/bowtie-0.12.7-src.zip'
  homepage 'http://bowtie-bio.sourceforge.net/index.shtml'
  sha1 '0eb752db072a2da6fc6dac55d2ab825422e994ce'

  def install
    system "make"
    bin.install %W(bowtie bowtie-build bowtie-inspect)
  end
end
