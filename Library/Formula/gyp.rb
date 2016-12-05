class Gyp < Formula
  desc "Generate Your Projects"
  homepage "https://gyp.gsrc.io/"
  url "https://chromium.googlesource.com/external/gyp",
    :using => :git,
    :revision => "7d29c3de1f5eb74330b81b78ea116b67f684b23b"
  version "0.1"

  depends_on :python

  def install
    system 'python', './setup.py',
                     'install',
                     "--prefix=#{prefix}",
                     "--single-version-externally-managed",
                     "--record=installed.txt"
    bin.install("gyp")
    bin.install("gyp_main.py")
  end

  test do
    system "gyp", "-h"
  end
end
