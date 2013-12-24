require 'formula'

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Therion < Formula
  homepage 'http://therion.speleo.sk'
  url 'http://therion.speleo.sk/downloads/therion-5.3.12.tar.gz'
  sha1 '6c9863225f87ce4b54792060ecb34a9db6f8197e'

  depends_on 'cmake' => :build
  depends_on 'lcdf-typetools'
  depends_on 'wxmac'
  depends_on 'freetype'
  depends_on 'vtk5'
  depends_on 'imagemagick'

  def install
    # Replace /usr/bin with PREFIX
    inreplace 'makeinstall.tcl', "/usr/bin" , "#{prefix}/bin"
    inreplace 'makeinstall.tcl', "/etc" , "#{prefix}/etc"
    system "mkdir -p #{prefix}/{bin,etc}"
    system "make config-macosx"
    system "make"
    system "make install"
  end

  def caveats
    s = <<-EOS.undent
        Before installing therion please install MacTex.
        You can find the package at http://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg
    EOS
  end
  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test therion`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "--version"`.
    system "false"
  end
end
