require 'formula'

class Bowtie < Formula
  homepage 'http://bowtie-bio.sourceforge.net/index.shtml'
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie/0.12.8/bowtie-0.12.8-src.zip'
  sha1 '56fd4dfd1d8ef995f041d11ce6078dd1e22a655f'

  def install
    system "make"
    bin.install %W(bowtie bowtie-build bowtie-inspect)
  end
end
