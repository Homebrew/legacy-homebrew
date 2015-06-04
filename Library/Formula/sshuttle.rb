require 'formula'
# for test
require 'open3'

class Sshuttle < Formula
  homepage 'https://github.com/sshuttle/sshuttle'
  url 'https://github.com/sshuttle/sshuttle/archive/sshuttle-0.71.tar.gz'
  sha256 '62f0f8be5497c2d0098238c54e881ac001cd84fce442c2506ab6d37aa2f698f0'

  head 'https://github.com/sshuttle/sshuttle.git'

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    libexec.install Dir['src/*']
    bin.write_exec_script libexec/'sshuttle'
  end
  test do
    cmd = '#{bin}/sshuttle --server'
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 1
      exit_status = wait_thr.value
      unless exit_status.success?
        abort "Test failed #{cmd}"
      end
    end
  end

end
