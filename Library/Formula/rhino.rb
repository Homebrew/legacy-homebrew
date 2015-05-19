require 'formula'

class Rhino < Formula
  desc "JavaScript engine"
  homepage 'https://www.mozilla.org/rhino/'
  url 'https://github.com/mozilla/rhino/releases/download/Rhino1_7_6_RELEASE/rhino1.7.6.zip'
  sha1 '7d86ccb422bc82569b334bad68cee385c3a4540c'

  def install
    libexec.install 'js.jar'
    bin.write_jar_script libexec/'js.jar', 'rhino'
  end

  test do
    system "#{bin}/rhino", '-e', 'print(42);'
  end
end
