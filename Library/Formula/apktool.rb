require 'formula'

class ApktoolExecutables < Formula
  url 'http://android-apktool.googlecode.com/files/apktool-install-macosx-r04-brut1.tar.bz2'
  sha1 'f3e7376225916d3fb73df618ec4e5f5c00474e0c'
end

class Apktool < Formula
  url 'http://android-apktool.googlecode.com/files/apktool1.4.1.tar.bz2'
  sha1 '4e5f709e5f86c3ef72dbc32041d1aebd957098b4'
  homepage 'http://android-apktool.googlecode.com/'

  def install
    libexec.install 'apktool.jar'

    ApktoolExecutables.new.brew do |f|
      # Make apktool look for jar in libexec
      inreplace 'apktool', /^libdir=.*$/, "libdir=\"#{libexec}\""
      bin.install ['aapt', 'apktool']
    end
  end
end
