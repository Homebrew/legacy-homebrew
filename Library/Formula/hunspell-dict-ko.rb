require 'formula'

class HunspellDictKo < Formula
  homepage 'http://code.google.com/p/spellcheck-ko/'
  url 'http://spellcheck-ko.googlecode.com/files/ko-aff-dic-0.5.5.zip'
  version '0.5.5'
  sha1 'a9b22ddc17bab82e7fc6b3a30eb1a5c061f970f5'

  def install
    prefix.install 'ko.aff'
    prefix.install 'ko.dic'
    system 'sudo mkdir -p /Library/Spelling'
    system "sudo ln -sf #{prefix}/ko.aff /Library/Spelling/ko.aff"
    system "sudo ln -sf #{prefix}/ko.dic /Library/Spelling/ko.dic"
  end

  def caveats; <<-EOS.undent
    This formula make following symbolic link files:
      /Library/Spelling/ko.aff
      /Library/Spelling/ko.dic

    To uninstall this formula completely, we should remove those files with following command:
      sudo rm -rf /Library/Spelling/ko.{aff,dic}
    EOS
  end
end
