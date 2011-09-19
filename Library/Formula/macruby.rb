require 'formula'

class Macruby < Formula
  version '0.10'
  head 'git://github.com/MacRuby/MacRuby.git'
  url 'https://nodeload.github.com/MacRuby/MacRuby/tarball/0.10'
  md5 '3716da78ec7ff4345bfd1bdaffae5b11'
  homepage 'http://www.macruby.org'

  depends_on 'llvm'

  def install
    framework = prefix.join('Library/Framework/')
    framework.mkpath
    rake_args = "framework_instdir=#{framework} sym_instdir=#{prefix}"
    system "/usr/bin/rake all #{rake_args}"
    system "/usr/bin/rake install #{rake_args}"
  end

  def test
    system "/usr/bin/rake spec"
  end
end
