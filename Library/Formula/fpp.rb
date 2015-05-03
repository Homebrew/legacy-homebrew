class Fpp < Formula
  homepage "https://facebook.github.io/PathPicker/"
  head "https://github.com/facebook/pathpicker/"
  version "0.0.3"
  # To be changed -- just a sample tar for now
  url "https://github.com/pcottle/example_for_pip/raw/master/dist/pcottleexample.tar.gz"
  sha256 "038753f944edf7b3d6b0dbcf0056350eead1e14db4a3c70fafb711e9a31be3d4"

  # I have a dependency on python 2.7 -- is this ok?
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  def install
    puts 'Unpacking PathPicker'
    # obviously a total hack -- my two questions:
    # -- how can I correctly access the destination of where url was downloaded?
    # -- how can I extract this tar correctly to somewhere permanent?
    system "tar xopf /Library/Caches/Homebrew/fpp-0.0.3.tar.gz -C /Users/pcottle/Desktop/"
    puts 'Symlinking bash script'
    # and this is a hack as well -- but basically i just want to symlink one file from the tar
    ln_sf '/Users/pcottle/Desktop/example', '/usr/local/bin/fpp'
  end

end
