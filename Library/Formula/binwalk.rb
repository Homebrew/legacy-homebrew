require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'https://binwalk.googlecode.com/files/binwalk-1.2.2-1.tar.gz'
  sha1 '3422427a326f58a5b04616111ee66a8c2fddec1d'

  depends_on 'libmagic' => 'with-python'

  option 'with-matplotlib', 'Check for presence of matplotlib, which is required for entropy graphing support'
  depends_on 'matplotlib' => :python if build.with? 'matplotlib'
  depends_on :python

  def install
    cd "src" do
      system "python", "setup.py", "install", "--no-prereq-checks", "--prefix=#{prefix}"
      bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
    end
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
