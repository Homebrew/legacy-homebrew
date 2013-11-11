require 'formula'

class Dub < Formula
  homepage 'http://registry.vibed.org/'
  url  'https://github.com/rejectedsoftware/dub/archive/v0.9.19.tar.gz'
  sha1 'dcf880029190180a1a4a4753237c0eb164941c98'

  head 'https://github.com/rejectedsoftware/dub.git'

  depends_on 'pkg-config' => :build
  depends_on 'dmd'  => :build

  # patch is in upstream master
  def patches
    [
      "https://github.com/rejectedsoftware/dub/commit/0e91afd52babf96128be43120dfd5f9a38b4d202.patch",
      "https://github.com/rejectedsoftware/dub/commit/b08454b6baa5c7e9e2d5a21c943c21cb986fff23.patch",
    ]
  end

  def install
    system "./build.sh"
    bin.install 'bin/dub'
  end

  test do
    system "#{bin}/dub; true"
  end
end
