class Blackbox < Formula
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20150203.tar.gz"
  version "1.20150203"
  sha1 "dbe69ab20924ecc5c02ad917a52a57ec1f01addd"

  def install
    bin.install 'bin/_blackbox_common.sh', 'bin/_stack_lib.sh', 'bin/blackbox_addadmin', 'bin/blackbox_cat', 'bin/blackbox_edit', 'bin/blackbox_edit_end', 'bin/blackbox_edit_start', 'bin/blackbox_initialize', 'bin/blackbox_postdeploy', 'bin/blackbox_register_new_file', 'bin/blackbox_removeadmin', 'bin/blackbox_shred_all_files', 'bin/blackbox_update_all_files'
  end
end
