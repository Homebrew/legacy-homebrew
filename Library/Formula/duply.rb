class Duply < Formula
  desc "Frontend to the duplicity backup system"
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20\(simple%20duplicity\)/1.11.x/duply_1.11.1.tgz"
  sha256 "128792962bbd1509e875bd91e613be3aa1263e6edb57815957e07d54346bc02d"

  bottle :unneeded

  depends_on "duplicity"

  def install
    bin.install "duply"
    # Homebrew uses env_script_all_files in the duplicity script, so calling it
    # with the python interpreter doesn't work
    inreplace "#{bin}/duply", "DEFAULT_PYTHON=\'python2\'", "DEFAULT_PYTHON=\'bash\'"
  end
end
