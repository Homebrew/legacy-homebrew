require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Depot < Formula
  homepage 'https://sites.google.com/a/chromium.org/dev/developers/how-tos/depottools'
  url 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
  sha1 ''

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    prefix.install Dir['*']
  end

  test do
    system "false"
  end
end
