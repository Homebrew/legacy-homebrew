class Napi < Formula
  desc "Napi Projekt Client and Subotage subtitle format converter"
  homepage "https://github.com/dagon666/napi"
  url "https://github.com/dagon666/napi/archive/v1.3.4.tar.gz"
  sha256 "32b8ee39e00e9ed8cbbdb02bb683ccbfb02bd1f109b1a1e9f97e5badbf12c996"

  depends_on "wget"
  depends_on "p7zip" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "media-info" => :optional
  depends_on "mplayer" => :optional

  # conditional fallback to BSD stat for MAC OSX
  patch do
    url "https://github.com/dagon666/napi/commit/b1b7cb3068e26da34360e4076737a147dff6a483.patch"
    sha256 "672e08d7447a2bf8e480b589074f1e342fdac3f6b9bdb5af9e03339524ffb95e"
  end

  # ./install.sh doesn't work on OS X due to missing option in sed invocation
  patch do
    url "https://github.com/dagon666/napi/commit/f7c0b2f430a43d50667a6c0c163852778b4eabb2.patch"
    sha256 "ea71da0b69620a41917ac20efecd97d1f200fbbf701b92f9c910727878c49d79"
  end

  def install
    bin.mkpath
    share.mkpath

    system "./install.sh", "--bindir", bin, "--shareddir", share
  end

  test do
    system bin/"napi.sh", "*"

    assert_equal 0, $?.exitstatus
  end
end
