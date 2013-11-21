require 'formula'

class Apktool < Formula
  homepage 'http://android-apktool.googlecode.com/'
  url 'https://android-apktool.googlecode.com/files/apktool1.5.2.tar.bz2'
  sha1 '2dd828cf79467730c7406aa918f1da1bd21aaec8'

  resource 'exes' do
    url 'https://android-apktool.googlecode.com/files/apktool-install-macosx-r05-ibot.tar.bz2'
    sha1 'c2fb262760ccd27530e58ccc4bbef4d4a7b0ab39'
  end

  def install
    libexec.install 'apktool.jar', resource('exes')

    # Make apktool look for jar and aapkt in libexec
    inreplace "#{libexec}/apktool" do |s|
      s.gsub! /^libdir=.*$/, "libdir=\"#{libexec}\""
      s.gsub! "PATH=$PATH:`pwd`;", "PATH=$PATH:#{libexec};"
    end

    bin.install_symlink libexec/'apktool'
  end
end
