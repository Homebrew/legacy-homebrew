require 'formula'

class Libcsv < Formula
  desc "CSV library in ANSI C89"
  homepage 'http://sourceforge.net/projects/libcsv/'
  url 'https://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.3/libcsv-3.0.3.tar.gz'
  sha1 '2f637343c3dfac80559595f519e8f78f25acc7c1'

  bottle do
    cellar :any
    revision 1
    sha1 "d247cc385fefdc1cadcb124f37df76ca173b4700" => :yosemite
    sha1 "601cf88b49e3c3a4e06265d4cf1ff0dac3cccb37" => :mavericks
    sha1 "6e87f90f6541f6cbf2f4df1b7e8c1a15059b509b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system 'make'
    system 'make install'
  end
end
