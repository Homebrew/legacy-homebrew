require 'formula'

# This formula is intended to be used by gcc formulae with java support.

class Ecj < Formula
  homepage 'http://gcc.gnu.org'
  url 'ftp://sourceware.org/pub/java/ecj-4.5.jar'
  mirror 'http://mirrors.kernel.org/sources.redhat.com/java/ecj-4.5.jar'
  sha1 '58c1d79c64c8cd718550f32a932ccfde8d1e6449'

  def install
    (share/'java').install "ecj-#{version}.jar" => 'ecj.jar'
  end
end
