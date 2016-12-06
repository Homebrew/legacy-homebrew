require 'formula'

class Fishfish < Formula
  homepage 'http://ridiculousfish.com/shell'

  url 'git://gitorious.org/~ridiculousfish/fish-shell/fishfish.git',
      :tag => 'OpenBeta_r2'
  version 'OpenBeta_r2'

  head 'git://gitorious.org/~ridiculousfish/fish-shell/fishfish.git',
       :branch => 'develop'

  depends_on 'autoconf' => :build
  depends_on 'doxygen' => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--without-xsel"
    system "make install"
  end

  def test
    system "fish -c 'echo'"
  end
end
