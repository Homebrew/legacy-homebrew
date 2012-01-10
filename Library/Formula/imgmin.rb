require 'formula'

class Imgmin < Formula
  url 'https://github.com/rflynn/imgmin/tarball/master'
  homepage 'https://github.com/rflynn/imgmin'
  md5 'b605c8c75c327fde4903c83ad95e7c5e'

  version '0.0.1'
  head 'https://github.com/rflynn/imgmin.git'

  depends_on 'imagemagick'
  
  def install
    system "make -C src imgmin"
  end
end