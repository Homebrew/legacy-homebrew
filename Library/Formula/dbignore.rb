require 'formula'

class Dbignore < Formula
  homepage 'http://konolige.com/dbignore/'
  url 'https://github.com/tkonolige/dbignore/releases/download/v0.4/dbignore_0.4.tar.gz'
  sha1 'eb86cd8d817235af489ed736b8587326d9e374fe'

  def install
    system "./install"
  end

  def caveats; <<-EOS.undent
    1) Your Dropbox.app must be located at /Applications/Dropbox.app
    2) You must restart dropbox after installation.
    
    INFO:
    Add a .dbignore to a directory to tell Dropbox to ignore certain files.
    Files will be ignored if they match any of the patterns in the .dbignore
    file.
    EOS
  end
end
