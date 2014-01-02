require 'formula'

class Atdtool < Formula
  homepage 'https://github.com/lpenz/atdtool'
  url 'https://github.com/lpenz/atdtool/archive/2103e80ca8ec5a2e059d68e310f4a95af65d6b78.zip'
  sha1 '3ceb71219599d6633e8dc48e6ac66369f2e4932d'
  version '1.3'

  depends_on :python
  depends_on 'txt2tags' => :build

  def install
    # Change the PREFIX to match the homebrew one, since there is no way to
    # pass it as an option for now edit the Makefile
    # https://github.com/lpenz/atdtool/pull/8
    inreplace 'Makefile', "PREFIX=/usr/local", "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/atdtool", "--version"
  end
end
