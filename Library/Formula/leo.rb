require 'formula'

# homebrew formula for Leo 5.1, version 2.

class Leo < Formula

  homepage 'http://leoeditor.com/'
  url 'http://sourceforge.net/projects/leo/files/Leo/5.0-final/Leo-5.0-final.zip'
  sha1 '9a8ca37688e60851b4faea3adfa30aae2156eb9f'
  
  head https://github.com/leo-editor/leo-editor, :using => :git

  depends_on 'pyqt'
  depends_on 'enchant' => :recommended
  depends_on :python if MacOS.version <= :snow_leopard
    # Ensure Python 2.6+.

  def install
    (lib+"python2.7/site-packages").install "leo"
    bin.install "launchLeo.py" => "leo" 
  end

  test do
    system "python -c 'import leo'"
  end
end
