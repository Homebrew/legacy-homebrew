require 'formula'

class Rabcdasm < Formula
  homepage 'https://github.com/CyberShadow/RABCDAsm'
  url 'https://github.com/downloads/CyberShadow/RABCDAsm/RABCDAsm_v1.13.7z', :using => 'p7zip'
  version '1.13'
  sha1 '38742f8e7ac5c96c1a5f781f25559a1856fa7e29'

  depends_on 'p7zip' => :build
  depends_on 'dmd' => :build
  depends_on 'xz' => :build

  def install
    system "dmd -run build_rabcdasm.d"

    bin.install 'abcexport', 'abcreplace', 'swfbinexport', 'swfbinreplace', 'swfdecompress', 'swf7zcompress', 'swflzmacompress'
  end

end
