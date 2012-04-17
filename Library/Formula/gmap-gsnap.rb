require 'formula'

class GmapGsnap < Formula
  homepage 'http://research-pub.gene.com/gmap'
  url 'http://research-pub.gene.com/gmap/src/gmap-gsnap-2012-04-10.tar.gz'
  md5 'acd1731524eb3517f6e82147c646d27d'
  version "2012-04-10"

  depends_on "samtools"

  def install
    ENV['CC'] = "#{ENV.cc} -O3 -m#{MacOS.prefer_64_bit? ? 64 : 32}"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats
    <<-EOF
    You will need to either download or build indexed search databases.

    See the readme file for how to do this:

    http://research-pub.gene.com/gmap/src/README

    Databases will be installed to #{prefix}/share.

    EOF
  end

  def test
    system "gsnap --version"
  end
end
