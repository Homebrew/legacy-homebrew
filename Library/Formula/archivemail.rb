require 'formula'

class Archivemail < Formula
  homepage 'http://archivemail.sourceforge.net/'
  url 'http://sourceforge.net/projects/archivemail/files/archivemail-0.9.0.tar.gz'
  md5 'ee36b3e8451ec563ae9338f3dd75e3f6'

  def install
    system "python", "setup.py", "install"
  end

end
