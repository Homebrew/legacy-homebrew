class Osxutils < Formula
  homepage "https://github.com/vasi/osxutils"
  head "https://github.com/vasi/osxutils.git"
  url "https://github.com/vasi/osxutils/archive/v1.8.1.tar.gz"
  sha1 "b6c0e2b0c699a4bf9d51c582c8107ce40cfdec8b"

  conflicts_with "trash", :because => 'both install a trash binary'
  conflicts_with "leptonica",
    :because => "both leptonica and osxutils ship a `fileinfo` executable."
  conflicts_with "googlecl", :because => 'both install a google binary'

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/trash"
  end
end
