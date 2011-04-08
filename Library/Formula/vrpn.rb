require 'formula'

class Vrpn < Formula
  url 'git://git.cs.unc.edu/vrpn.git', :tag => 'version_07.28'
  version '07.28'
  homepage 'http://vrpn.org'

  depends_on 'cmake' => :build

  def options
    [['--clients', 'Build client apps and tests.']]
  end

  def install
    args = [ "#{std_cmake_parameters}" ]

    if ARGV.include? '--clients'
      args << "-DVRPN_BUILD_CLIENTS:BOOL=ON"
    else
      args << "-DVRPN_BUILD_CLIENTS:BOOL=OFF"
    end

    args << ".."

    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake", *args
      system "make install"
    end
  end
end
