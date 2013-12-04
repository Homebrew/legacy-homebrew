require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://dl.dropbox.com/u/133901206/storm-0.8.2.zip'
  sha1 'abb533c90f5b9eeaafb9136670091fc894fce169'

  devel do
    url 'https://dl.dropboxusercontent.com/s/p5wf0hsdab5n9kn/storm-0.9.0-rc2.zip'
    sha1 '1fc891d29259a431bcd297cbcc24888152cc25bb'
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end
