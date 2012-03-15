require 'formula'

class Openni < Formula
  head "https://github.com/OpenNI/OpenNI.git"
  homepage 'http://75.98.78.94/'

  depends_on 'libusb' #Requires the --universal flag
  depends_on 'doxygen'
  depends_on 'graphviz'

  def install
    cd "Platform/Linux/CreateRedist" do
      system "bash RedistMaker"

      cd "Final" do
        tarfile = Dir.glob('*.tar.bz2').first
        system "tar xvf #{tarfile}"

        untardir = tarfile.split(".tar.bz2").first
        cd untardir do
          lib.install Dir.glob('Lib/*.dylib')
          lib.install Dir.glob('Lib/*.dylib')
          bin.install 'Bin/niLicense'
          bin.install 'Bin/niReg'
          include.install Dir.glob('Include/*.h')
          system("mkdir #{include}/MacOSX")
          system("cp Include/MacOSX/XnPlatformMacOSX.h #{include}/MacOSX")
          system("cp -r Include/MacOSX #{include}")
          system("cp -r Include/Linux-x86 #{include}")
        end
      end
    end

  end

  def test
    system "niLicense -l"
  end
end
