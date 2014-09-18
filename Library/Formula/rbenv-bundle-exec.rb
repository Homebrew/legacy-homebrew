require "formula"

class RbenvBundleExec < Formula
  homepage "https://github.com/maljub01/rbenv-bundle-exec"
  url "https://github.com/maljub01/rbenv-bundle-exec/archive/v1.0.0.tar.gz"
  sha1 "2094ce0ac8f53b500f35a1a1b47a654a42611a35"

  head "https://github.com/maljub01/rbenv-bundle-exec.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    SCRIPTNAME = "test_rbenv-bundle-exec.sh"

    script = <<-SCRIPT
      #!/usr/bin/env bash
      set -e

      # Setting this variable results in `bundle exec ruby <cmd>` being echoed
      # where bundle exec is automatically inserted by the plugin
      export DEBUG_RBENV_BUNDLE_EXEC=true
      cd #{testpath}
      echo '#!/usr/bin/env ruby' > test_ruby_program
      chmod +x test_ruby_program

      # There shouldn't be any output since there is no Gemfile
      output=$((./test_ruby_program) 2>&1)
      [[ $output = '' ]] || exit 1

      touch Gemfile

      # `bundle exec ruby <cmd>` should be echoed
      output=$((./test_ruby_program) 2>&1)
      [[ $output = 'bundle exec ruby ./test_ruby_program' ]] || exit 1
    SCRIPT

    (testpath/SCRIPTNAME).write(script)
    system "chmod +x #{testpath}/#{SCRIPTNAME}"
    system "#{testpath}/#{SCRIPTNAME}"
  end
end
