require "formula"

class Reclass < Formula
  homepage "http://reclass.pantsfullofunix.net/"
  url "https://github.com/madduck/reclass/archive/reclass-1.3.tar.gz"
  sha1 "eaa8eb1fd22aa040fa7a57c613c6223706904578"

  head 'https://github.com/madduck/reclass.git'

  depends_on :python

  def install
    ENV.prepend_create_path 'PYTHONPATH', "#{libexec}/lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/'bin/*']
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/reclass", "--version"
  end
end
