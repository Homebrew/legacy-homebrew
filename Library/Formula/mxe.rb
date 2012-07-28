require 'formula'

class Mxe < Formula
  homepage 'http://mxe.cc/'
  head 'https://github.com/mxe/mxe.git'
  url 'https://github.com/mxe/mxe/zipball/b1b864500a9586b366e944c211a1f6e09531cc12'
  sha1 '4422509acb65fc752cffe3af8704e8dd316942b9'
  version 'stable-2012-06-13'
  
  depends_on 'autoconf' => :build
  depends_on 'cmake'    => :build
  depends_on 'gnu-sed'  => :build
  depends_on 'intltool' => :build
  depends_on 'scons'    => :build
  depends_on 'xz'       => :build
  depends_on 'wget'     => :build
  depends_on 'yasm'     => :build

  def options
    [["--all-pkgs", "Build optional libraries"]]
  end

  def install
    inreplace 'Makefile', '$(PWD)/usr', prefix

    cmd = 'make'
    cmd << ' gcc' unless ARGV.include? '--all-pkgs'
    cmd << ' >/dev/tty'

    system cmd
  end
 end
