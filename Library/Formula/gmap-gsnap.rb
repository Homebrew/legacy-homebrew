require 'formula'

class GmapGsnap < Formula
  homepage 'http://research-pub.gene.com/gmap'
  url 'http://research-pub.gene.com/gmap/src/gmap-gsnap-2012-07-20.tar.gz'
  sha1 '9edb7750b923842f9c877f59934cdfd9f5cdf2b7'
  version "2012-07-20"

  depends_on "samtools"

  def install
    ENV['CC'] = "#{ENV.cc} -O3 -m#{MacOS.prefer_64_bit? ? 64 : 32}"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOF.undent
    You will need to either download or build indexed search databases.
    See the readme file for how to do this:
      http://research-pub.gene.com/gmap/src/README

    Databases will be installed to:
      #{share}
    EOF
  end

  def test
    system "#{bin}/gsnap", "--version"
  end
end
