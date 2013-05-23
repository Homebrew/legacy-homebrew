require 'formula'

class Hepmc < Formula
  homepage 'http://lcgapp.cern.ch/project/simu/HepMC/'
  url 'http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-2.06.09.tar.gz'
  sha1 'ecb97190abedfe774629a1cbc961910b4d83b7d6'

  depends_on 'cmake' => :build

  def install
    # Build directory must be outside source directory tree
    srcDir = Dir.pwd
    mkdir '../build' do
      system "cmake", "#{srcDir}", "-Dmomentum:STRING=GEV", "-Dlength:STRING=MM", *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
