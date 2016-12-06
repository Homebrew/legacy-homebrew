require 'formula'

class Powerline < Formula
  homepage 'https://github.com/Lokaltog/powerline'
  head 'https://github.com/Lokaltog/powerline.git', :branch => :develop

  depends_on 'python'

  def install
    system 'pip install --user git+git://github.com/Lokaltog/powerline'
  end

  def caveats; <<-EOS.undent
    Font installation
      You need a patched font for Powerline to work on OS X.
      https://powerline.readthedocs.org/en/latest/installation/osx.html#font-installation

    Troubleshooting
      https://powerline.readthedocs.org/en/latest/installation/osx.html#troubleshooting
    EOS
  end
end
