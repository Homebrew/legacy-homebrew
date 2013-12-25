require 'formula'

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Rdfind < Formula
  homepage 'http://rdfind.pauldreik.se'
  url 'http://rdfind.pauldreik.se/rdfind-1.3.4.tar.gz'
  sha1 'c01bd2910cdec885b6c24164a389457e4f01ef61'

  depends_on 'nettle'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rdfind", "--version"
  end
end
