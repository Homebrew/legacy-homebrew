require 'formula'

class Rhino < Formula
  homepage 'http://www.mozilla.org/rhino/'
  url 'https://github.com/downloads/mozilla/rhino/rhino1_7R4.zip'
  sha1 '483e097cb575c724c745edd80c9512f073bd510a'
  version '1.7R4'

  def install
    libexec.install 'js.jar'
    bin.write_jar_script libexec/'js.jar', 'rhino'
  end
end
