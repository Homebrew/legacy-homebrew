require 'formula'

class Rhino < Formula
  homepage 'https://www.mozilla.org/rhino/'
  url 'https://github.com/mozilla/rhino/releases/download/Rhino1_7R5_RELEASE/rhino1_7R5.zip'
  sha1 '39ada4cca8c7f651a68eda3f307ff9b68808f0ce'
  version '1.7R5'

  def install
    libexec.install 'js.jar'
    bin.write_jar_script libexec/'js.jar', 'rhino'
  end

  test do
    system "#{bin}/rhino", '-e', 'print(42);'
  end
end
