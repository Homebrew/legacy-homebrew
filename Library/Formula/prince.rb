require "formula"

class Prince < Formula
  homepage "http://www.princexml.com/"
  url "http://www.princexml.com/download/prince-9.0r4-macosx.tar.gz"
  sha1 "692c1aff7081c8569ba6afb8341aba0788cbf456"

  version '9.0r4'

  def install
    system "echo #{prefix} | ./install.sh"
  end
end
