require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'https://binwalk.googlecode.com/files/binwalk-1.2.2-1.tar.gz'
  sha1 '3422427a326f58a5b04616111ee66a8c2fddec1d'

  depends_on 'libmagic' => 'with-python'

  option 'with-matplotlib', 'Check for presence of matplotlib, which is required for entropy graphing support'
  if build.with? 'matplotlib'
    depends_on :python => 'matplotlib'
  else
    depends_on :python
  end

  def install
    cd "src" do
      system python, "setup.py", "install", "--no-prereq-checks", "--prefix=#{prefix}"
    end
  end
end
