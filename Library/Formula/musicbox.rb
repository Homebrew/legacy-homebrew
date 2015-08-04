class MusicBox < Formula
  desc "A sexy command line interface musicbox"
  homepage "https://github.com/darknessomi/musicbox"
  url "https://pypi.python.org/packages/source/N/NetEase-MusicBox/NetEase-MusicBox-0.1.6.5.tar.gz#md5=f731f7c94804a42d2acde2825dba37e1"
  version "0.1.6.5"
  sha256 "8383d773bd1d4f5e1f4b41897fe34e3dac25c47d3f1b59f1cef62c35ce14a07e"
  sha1 "d2f8cf412ba4a963ed76ec4dee2dc6fcd34a5652"

  depends_on :mpg123 

  def install
    system "sudo", "python", "setup.py", "install"
  end

end
