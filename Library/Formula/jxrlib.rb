require 'formula'

class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage 'https://jxrlib.codeplex.com/'

  head 'https://git01.codeplex.com/jxrlib', :using => :git

  def install
    system "make install DIR_INSTALL=#{prefix}"
  end
end
