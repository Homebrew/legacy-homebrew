require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.org'
  url 'http://xrootd.org/download/v3.3.5/xrootd-3.3.5.tar.gz'
  sha1 '103be7641ef0e7a3a4f6686641a8dc207eb4cf7f'

  depends_on 'cmake' => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
    share.install prefix/'man'
  end

  def test
    system "#{bin}/xrootd", "-H"
  end
end
