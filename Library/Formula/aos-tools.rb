require 'formula'

class AosTools < Formula
  homepage 'http://code.google.com/p/aos-tools/'
  url 'http://cdn.podhurl.com/Hk9o/download/aos-tools_20120629.tgz'
  sha1 'dadad04d22a7d868e8d2e861500590c3821463a9'

  def patches
    # fixes a conflict with the encrypt variable on OS X
    # See also: https://code.google.com/p/aos-tools/issues/detail?id=1
    { :p0 => "http://aos-tools.googlecode.com/issues/attachment?aid=10000000&name=mac_libs.patch&token=bjvbvh1dMhnm9bF5qCizxxJg_uo%3A1340989161641" }
  end

  def install
    # Build library for tools.
    cd 'libaos' do
      system "make"
    end

    # Build tools.
    cd 'tools' do
      system "make"
      bin.install 'aos-info'
      bin.install 'aos-unpack'
      bin.install 'aos-fix'
      bin.install 'aos-repack'
      end

  end

  def test
    system "aos-info"
  end
end
