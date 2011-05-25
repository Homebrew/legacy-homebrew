require 'formula'

class Mrbayes < Formula
  head 'https://mrbayes.svn.sourceforge.net/svnroot/mrbayes/trunk/src/'
  homepage 'http://mrbayes.csit.fsu.edu/'

  def options
    [
      ["--enable-beagle", "Compile with beagle-lib support."],
      ["--disable-mpi", "Compile without MPI support."]
    ]
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--enable-sse"]
    args << "--with-beagle=no" unless ARGV.include? "--enable-beagle"
    args << "--enable-mpi" unless ARGV.include? "--disable-mpi"
    system "autoconf"
    system "./configure", *args
    system "make"
    bin.install "mb"
  end
end
