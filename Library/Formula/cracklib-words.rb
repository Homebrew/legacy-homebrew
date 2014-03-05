require 'formula'

class CracklibWords < Formula
  homepage 'http://cracklib.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/cracklib/cracklib-words/2008-05-07/cracklib-words-20080507.gz'
  sha1 'e0cea03e505e709b15b8b950d56cb493166607da'

  depends_on 'cracklib'

  def install
    share.install "cracklib-words-#{version}" => "cracklib-words"
    system "/bin/sh", "-c", "#{HOMEBREW_PREFIX}/sbin/cracklib-packer < #{share}/cracklib-words"
  end
end
