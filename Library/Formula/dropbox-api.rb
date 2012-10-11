require 'formula'

class DropboxApi <Formula
  head 'git://github.com/s-aska/dropbox-api-command.git'
  homepage 'https://github.com/s-aska/dropbox-api-command'

  depends_on 'cpanm'

  def install
    bin.install 'dropbox-api'
  end

  def caveats; <<-EOS.undent
      ========== you must install the Perl Module ==========
        $ cpanm --sudo JSON Path::Class WebService::Dropbox DateTime::Format::Strptime Encode::Locale Encode::UTF8Mac
      ======================================================
    EOS
  end
end
