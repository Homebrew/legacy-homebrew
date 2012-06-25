require 'formula'

class Eg < Formula
  homepage 'http://people.gnome.org/~newren/eg/'
  url 'http://people.gnome.org/~newren/eg/download/1.7.3/eg'
  sha1 'd17165c20ea1b3887f1f81ec6d1217727b817409'
  version "1.7.3"

  def install
    bin.install "eg"
  end

  def test
    system "eg help"
  end
end
