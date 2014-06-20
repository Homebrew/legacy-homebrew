require 'formula'

class Atdtool < Formula
  homepage 'https://github.com/lpenz/atdtool'
  url 'https://github.com/lpenz/atdtool/archive/upstream/1.3.tar.gz'
  sha1 '0e6ac49a106912f010f3cb71dec59ef5c29ad108'

  depends_on 'txt2tags' => :build

  def install
    # Change the PREFIX to match the homebrew one, since there is no way to
    # pass it as an option for now edit the Makefile
    # https://github.com/lpenz/atdtool/pull/8
    inreplace 'Makefile', "PREFIX=/usr/local", "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/atdtool", "#{prefix}/AUTHORS"
  end
end
