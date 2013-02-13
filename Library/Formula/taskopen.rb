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
    Copy in the sample taskopen configuration and edit it to make any changes
    necessary:

      $ cp #{prefix}/taskopenrc ~/.taskopenrc

    * You man need to update the task path to be /usr/local/bin/task

    If you want the ability to send tasks from mutt to taskwarrior, add the
    following lines your your muttrc file:

    macro index ,k "<pipe-message>mutt2task<enter> <copy-message>+TODO<enter>"
    macro index ,m "<pipe-message>mess2task<enter>"
    macro index ,t "<pipe-message>mess2task2<enter>"

    EOS
  end
end
