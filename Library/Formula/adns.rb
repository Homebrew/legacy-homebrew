class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "http://www.chiark.greenend.org.uk/~ian/adns/"
  url "http://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.5.0.tar.gz"
  sha256 "7fc5eb4d315111a3a3a3f45ff143339ad4050185fbe6bff687f21364cb4ae841"
  head "git://git.chiark.greenend.org.uk/~ianmdlvl/adns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2534e08973313ece99276f31d01384fff14568a078949614ea2d67189e4c0b1" => :el_capitan
    sha256 "9b9728bd1f4d0c491ab8b2a2343cc0bd8f9817e60944e3dcca01915cf5b9d55c" => :yosemite
    sha256 "5d0c4286ace0fa748e02052a865f36bc16fc2e57787701c47240c06567a2fd13" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/adnsheloex", "--version"
  end
end
