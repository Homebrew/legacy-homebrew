require 'formula'

class Taskopen < Formula
  homepage 'https://github.com/ValiValpas/taskopen'
  url 'https://github.com/ValiValpas/taskopen/archive/2.0.zip'
  sha1 '50760d0ce14fa7269429d20eac2a157a8860a826'
  version '2.0'

  depends_on 'task'
  depends_on 'gawk'

  def install
    bin.install "mess2task"
    bin.install "mess2task2"
    bin.install "mutt2task"
    bin.install "taskopen"
    prefix.install "taskopenrc"
    prefix.install "taskopenrc_vimnotes"
  end

  def caveats; <<-EOS.undent
    Copy in the sample taskopen configuration and edit it to make any changes necessary
      $ cp #{prefix}/taskopenrc ~/.taskopenrc

    Note: You man need to update the task path to be /usr/local/bin/task
    EOS
  end
end


