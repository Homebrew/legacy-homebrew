require 'formula'

class Worklog < Formula
  homepage 'https://github.com/regius/worklog'
  url 'https://raw.github.com/regius/worklog/v0.1/worklog.py'
  sha1 'f035f7c9ab16318d72509e684e8a0ca5723403cc'
  version '0.1'

  def install
    bin.install('worklog.py' => 'worklog')
  end
end
