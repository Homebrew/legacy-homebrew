require 'formula'

class Depot < Formula
  homepage 'https://sites.google.com/a/chromium.org/dev/developers/how-tos/depottools'
  url 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
  sha1 ''

  def install
    prefix.install Dir['*']
  end

  test do
    system "false"
  end
end
