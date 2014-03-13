require "formula"

class Cspice < Formula
  homepage "http://naif.jpl.nasa.gov/naif/index.html"
  url "http://naif.jpl.nasa.gov/pub/naif/toolkit//C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  sha1 "e5546a72a2d0c7e337850a10d208014efb57d78d"
  version "64"

  def install
    prefix.install Dir["*"]
    rm_f Dir["#{lib}/*"]
    rm_f Dir["#{prefix}/exe/*"]

    chdir "#{prefix}"
    system "csh", "#{prefix}/makeall.csh"

    Dir["#{lib}/*"].each do |file|
      symlink file, "#{lib}"+"/lib"+File.basename(file)
    end

    mv "#{prefix}/exe", "#{bin}"
  end

  test do
    system "#{bin}/tobin #{prefix}/data/cook_01.tsp DELME"
  end
end
