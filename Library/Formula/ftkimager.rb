require 'formula'

class Ftkimager <Formula
  url 'http://www.accessdata.com/downloads/current_releases/imager/FTK%20ImagerCLI%202.9.0_Mac.zip'
  homepage 'http://www.accessdata.com/downloads.html#FTKImager'
  version '2.9.0'
  md5 '5b33f0ec0c6d5096371f07d19cc698de'

  def install
    bin.install 'ftkimager'
  end
end
