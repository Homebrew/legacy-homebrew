require 'formula'

class Sundown < Formula
  homepage 'https://github.com/tanoku/sundown'
  url 'https://github.com/sschober/sundown/zipball/0.1'
  md5 '12adf82875a8c9222872934076f839ca'

  def install
    system "make libsundown.dylib all"
    include.mkpath
    include.install 'src/markdown.h', 'html/html.h', 'src/buffer.h', 'src/autolink.h'
    lib.mkpath
    lib.install 'libsundown.dylib'
    bin.mkpath
    bin.install 'sundown', 'smartypants'
    prefix.install 'README.markdown'
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test sundown`.
    system "false"
  end
end
