require "formula"

class Wakatime < Formula
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/source/w/wakatime/wakatime-2.1.6.tar.gz"
  sha1 "e288befaeefaaeec303efa36f2b7488829a6cf0d"

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    resources.each do |r|
        r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/wakatime", "--help"
  end
end
