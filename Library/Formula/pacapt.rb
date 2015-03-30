class Pacapt < Formula
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt.git",
    :revision => "70cae6c4022696decb6ac1f807a00049e589d9d4",
    :tag => "v2.0.2"

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
