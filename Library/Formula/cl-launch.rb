require "formula"

class ClLaunch < Formula
  homepage "http://cliki.net/CL-Launch"
  url "http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.1.tar.gz"
  sha1 "03dde08bcb3eee5d354240778b58b78f76fde8e5"

  def install
    system "make"
    system "mkdir #{prefix}/bin"
    system "cp cl-launch #{prefix}/bin/cl-launch"
    system "ln -s #{prefix}/bin/cl-launch #{prefix}/bin/cl"
  end
end
