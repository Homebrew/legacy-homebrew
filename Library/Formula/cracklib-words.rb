require 'formula'

class CracklibWords < Formula
  homepage 'http://cracklib.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/cracklib/cracklib-words/2008-05-07/cracklib-words-20080507.gz',
    :using => :nounzip
  sha1 'e0cea03e505e709b15b8b950d56cb493166607da'

  depends_on 'cracklib'

  def install
    system "gzip", "-d", "cracklib-words-20080507.gz"
    share.install "cracklib-words-20080507" => "cracklib-words"
    system "/bin/sh", "-c", "#{HOMEBREW_PREFIX}/sbin/cracklib-packer < #{share}/cracklib-words"
  end
end
