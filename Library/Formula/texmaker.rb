require 'formula'

class Texmaker < Formula
  homepage 'http://www.xm1math.net/texmaker/'
  version '4.0.3'

  case
    when MacOS.version >= :lion
      ohai 'Using Texmaker for MacOS Lion/Mountain Lion'
      url 'http://www.xm1math.net/texmaker/TexmakerMacosxLion.zip'
      sha1 'f532e7429cc7ed3436a4089480d026affc889db4'
    when MacOS.version >= :snow_leopard
      ohai 'Using Texmaker for MacOS Snow Leopard'
      url 'http://www.xm1math.net/texmaker/TexmakerMacosx64.zip'
      sha1 '43d78e29f9379a3f65c71931361e0660fd413507'
    when MacOS.version >= :leopard
      ohai 'Using Texmaker for MacOS Leopard'
      url 'http://www.xm1math.net/texmaker/TexmakerMacosx32.zip'
      sha1 '4b256ce787faad4a8c95e55598a50a3f8809b0cc'
    else
      onoe 'Error! Current Texmaker release is not available for your MacOS version.'
  end

  def install
   libexec.install Dir['*']
  end

  def post_install
    ln_sf(libexec+'texmaker.app','/Applications/texmaker.app')
  end

  def caveats
    <<-EOS.undent
      The symbolic link to Texmaker is not removed when:
      'brew remove texmaker' is run.
      You should run 'rm -f /Applications/texmaker.app'
      to remove it manually.
    EOS
  end
end
