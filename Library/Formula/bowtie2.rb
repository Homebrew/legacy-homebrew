require 'formula'

class Bowtie2 < Formula
  homepage 'http://bowtie-bio.sourceforge.net/bowtie2/index.shtml'
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.0.0-beta7/bowtie2-2.0.0-beta7-source.zip'
  sha1 '6e144be8bd376f469d6948ad1cc968c90ba579da'
  version '2.0.0-beta7'

  def install
    system "make"
    bin.install %W(bowtie2 bowtie2-align bowtie2-build bowtie2-inspect)
  end

  def test
    system "bowtie2"
  end
end
