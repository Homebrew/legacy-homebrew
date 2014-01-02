require 'formula'

class Atdtool < Formula
  homepage 'https://github.com/lpenz/atdtool'
  url 'https://github.com/lpenz/atdtool/archive/upstream/1.3.zip'
  sha1 '753abbfccd29d88abe774c032e58ea9428d8f6db'

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
    system "#{bin}/atdtool", "#{prefix}/AUTHORS"
  end
end
