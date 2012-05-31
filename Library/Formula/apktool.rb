require 'formula'

class ApktoolExecutables < Formula
  url 'http://android-apktool.googlecode.com/files/apktool-install-macosx-r04-brut1.tar.bz2'
  sha1 'f3e7376225916d3fb73df618ec4e5f5c00474e0c'
end

class Apktool < Formula
  homepage 'http://android-apktool.googlecode.com/'
  url 'http://android-apktool.googlecode.com/files/apktool1.4.3.tar.bz2'
  sha1 '7c0b85882c1fab7660258ab344e3a43b17e10741'

  def install
    libexec.install 'apktool.jar'

    ApktoolExecutables.new.brew do |f|
      # Make apktool look for jar in libexec
      inreplace 'apktool', /^libdir=.*$/, "libdir=\"#{libexec}\""
      bin.install 'aapt', 'apktool'
    end
  end
end
